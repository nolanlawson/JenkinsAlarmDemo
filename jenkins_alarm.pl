#!/usr/bin/env perl
# Blame the person who last broke the build, or praise the person who last fixed the build
# Speak it aloud using Android Text-to-Speech with attached Android device
# Also set the flag to be at the right angle, depending on whether the build is broken or not.
# Also play some beeping music.
#
# usage: just put it in a crontab to run every 5 minutes or so
#
use strict;
use LWP::Simple qw /get/;
use File::Basename qw/dirname/;
use File::Slurp;
use URI;

# your jenkins URL, with credentials if required
our $baseUrl = 'http://username:password@mysite.com/jenkins';

# optional map of user names to the string that the text-to-speech app should speak,
# useful for when the TTS typically mangles someone's name
our %nameMappings = (
    'ljiljana'  => 'liliana',
    'l.dolamic' => 'liliana',
);

our $brokenJobFile = '/tmp/jenkins_last_broken_project.txt';
our $lastStatusFile = '/tmp/jenkins_last_status.txt';

# -1000 should angle the flag down, 1000 should angle it up
our $badStatus = -1000;
our $goodStatus = 1000;

our $baseUri = URI->new($baseUrl);

sub getResponsibleUserForBuild {
    my $build = shift;
    
    my $buildXml = get($baseUri->scheme . '://' . $baseUri->authority . URI->new($build)->path . '/api/xml');

    $buildXml =~ /<(?:userName|fullName)>(?<fixedUser>[^<]+)<\/(?:userName|fullName)>/s;
    
    my $user = $+{fixedUser} || 'someone';

    # massage the user name for TTS
    $user = $nameMappings{$user} || $user;
}

sub getLastFailedBuildForJob {
    my $job = shift;
    my $jobXml = get($baseUri->scheme . '://' . $baseUri->authority . URI->new($job)->path . '/api/xml');

    $jobXml =~ /<url>(?<brokenBuild>[^<]+)<\/url><\/build>/s;
    return $+{brokenBuild};
}

sub getLastSuccessfulBuildForJob {

    my $job = shift;
    my $jobXml = get($baseUri->scheme . '://' . $baseUri->authority . URI->new($job)->path . '/api/xml');

    $jobXml =~ /<lastSuccessfulBuild>.*?<url>(?<fixedBuild>[^<]+)<\/url>[^<]*?<\/lastSuccessfulBuild>/s;    
    return $+{fixedBuild};
}

sub getLastBrokenJob {

    my $xml = get("$baseUrl/api/xml");
    $xml =~ /<url>(?<brokenJob>[^<]+)<\/url><color>[ry]/s;
    return $+{brokenJob};
}

sub getJobName {
    my $job = shift;
    my $jobXml = get($baseUri->scheme . '://' . $baseUri->authority . URI->new($job)->path . '/api/xml');
    
    $jobXml =~ /<displayName>(?<jobName>[^<]+)<\/displayName>/s;
    return $+{jobName};
}

sub praiseUser {
    my $job = read_file($brokenJobFile) or die 'cannot open last broken job file';
    my $fixedBuild = getLastSuccessfulBuildForJob($job) or die "cannot find last build for job $job";
    my $user = getResponsibleUserForBuild($fixedBuild);   
    my $jobName = getJobName($job);
    
    #speak via Android TTS
    my $textToSpeak = "Hooray! $user fixed the build, in the project $jobName.";
    print $textToSpeak . "\n";
    my $ttsCmd = qw(adb shell am start -n com.nolanlawson.android.simpletalker\/.MainActivity -e text);
    system ($ttsCmd, $textToSpeak);
}

sub blameUser {

    my $job = getLastBrokenJob();
    my $brokenBuild = getLastFailedBuildForJob($job);
    my $user = getResponsibleUserForBuild($brokenBuild);
    my $jobName = getJobName($job);
    
    # remember the broken build for later
    open (MYFILE, ">$brokenJobFile");
    print MYFILE $job;
    close (MYFILE);
    
    #speak via Android TTS
    my $textToSpeak = "Whoops! $user broke the build, in the project $jobName.";
    print $textToSpeak . "\n";
    my $ttsCmd = qw(adb shell am start -n com.nolanlawson.android.simpletalker\/.MainActivity -e text);
    system ($ttsCmd, $textToSpeak);

}

my $oldStatus = read_file($lastStatusFile, err_mode => 'quiet') || $badStatus;

my $xml = get("$baseUrl/api/xml");
my $angle=($xml=~/<color>[ry]/)?$badStatus:$goodStatus;  
my $cmd=dirname($0) . "/flagit 1 $angle";
system $cmd;

system "echo $angle > $lastStatusFile";

#play some music and speak, if the status changed
if ($oldStatus != $badStatus && $angle == $badStatus) {
        #bad status change
        system dirname($0).'/play_imperial_march.sh';
        blameUser();
} elsif ($oldStatus == $badStatus && $angle != $badStatus) {
        #good status change
        system dirname($0).'/play_star_wars_theme.sh';
        praiseUser();
}

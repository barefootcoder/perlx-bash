use Test::Most 		0.25;
use Test::Command	0.08;

use PerlX::bash;

# local test modules
use File::Spec;
use Cwd 'abs_path';
use File::Basename;
use lib File::Spec->catdir(dirname(abs_path($0)), 'lib');
use SkipUnlessBash;


my $uninit_msg = q|Use of uninitialized argument to bash|;

throws_ok { bash } qr/Not enough arguments/, 'bash with no args dies';
throws_ok { bash echo => undef } qr/$uninit_msg/, 'bash with an undefined arg dies';
throws_ok { bash \lines => } qr/Not enough arguments/, 'bash with only capture args dies';
throws_ok { bash -c => } qr/Not enough arguments/, 'bash with only switch args dies';
throws_ok { bash \lines => -c => } qr/Not enough arguments/, 'bash with only capture _and_ switch args dies';

# You would think you could wrap a `warning_is` inside a `dies_ok` here.
# You would be wrong.
perl_error_is( "bash with first arg undefined doesn't throw bogus warning", $uninit_msg, <<'END');
    use PerlX::bash;
    bash undef;
END



# These are stolen shamelessly from my personal test suite for "myperl" (Test::myperl).
# original lives at: https://github.com/barefootcoder/common/blob/master/perl/myperl/t/Test/myperl.pm

sub _perl_command
{
	my $cmd = shift;
	return [ $^X, '-e', $cmd, '--', @_ ];
}

sub perl_error_is
{
	my ($tname, $expected, $cmd, @extra) = @_;

	if ( ref $expected eq 'Regexp' )
	{
		stderr_like(_perl_command($cmd, @extra), $expected, $tname);
	}
	elsif ( $expected =~ /\n\Z/ )
	{
		stderr_is_eq(_perl_command($cmd, @extra), $expected, $tname);
	}
	else
	{
		my $regex = qr/^\Q$expected\E( at \S+ line \d+\.)?\n/;
		stderr_like(_perl_command($cmd, @extra), $regex, $tname);
	}
}


done_testing;

use v6;
use Test;

BEGIN { @*INC.push('lib') };

use Override;

plan 3;

sub throws_like($code, $ex_type, *%matcher) is export {
    my $msg;
    if $code ~~ Callable {
        $msg = 'code dies';
        $code()
    } else {
        $msg = "'$code' died";
        eval $code;
    }
    ok 0, $msg;
    skip 'Code did not die, can not check exception', 1 + %matcher.elems;
    CATCH {
        default {
            ok 1, $msg;
            my $type_ok = $_ ~~ $ex_type;
            ok $type_ok , "right exception type ({$ex_type.^name})";
            if $type_ok {
                for %matcher.kv -> $k, $v {
                    my $got = $_."$k"();
                    my $ok = $got ~~ $v,;
                    ok $ok, ".$k matches {$v.defined ?? $v !! $v.gist}";
                    unless $ok {
                        diag "Got:      $got\n"
                            ~"Expected: $v";
                    }
                }
            } else {
                diag "Got:      {$_.WHAT.gist}\n"
                    ~"Expected: {$ex_type.gist}";
                diag "Exception message: $_.message()";
                skip 'wrong exception type', %matcher.elems;
            }
        }
    }
}


{
	eval_lives_ok Q<<
		use Override;	
		my class A {
			method foo {}
		}
		my class B is A { 
			method foo is override {}
		}
	>>;
	throws_like Q<<
		use Override;
		my class A {}
		my class B is A { 
			method foo is override {}
		}
	>>, X::Override::Missing;
}


use v6;
use Test;

BEGIN { @*INC.push('lib') };
plan 1;

eval_lives_ok "use Override;";

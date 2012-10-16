module Override;

class X::Override::Missing does X::Comp is export {
        has $.type;
        has $.method;
        method message() {
                "Method $.method of type $.type doesn't override anything"
        }
}

multi trait_mod:<is>(Method:D $m, :$override!) is export {
        my $pkg := $m.signature.params[0].type;
        my $m_name := $m.name;
        for $pkg.HOW.parents($pkg) -> $p {
                return if $p.HOW.methods($p).grep(*.name eq $m_name);
        }
        X::Overload::Missing.new(:type($pkg.HOW.name($pkg)), :method($m)).throw;

}
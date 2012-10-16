module Overload;

class X::Overload::Missing is Exception {
	has $.type;
	has $.method;
	method message() {
		"Method $.method of type $.type doesn't override anything"
	}
}

multi trait_mod:<is>(Method:D $m, :$overload!) {
	my $pkg := $m.signature.params[0].type;
	my $m_name := $m.name;
	for $m.parents -> $p {
		return if $p.HOW.methods($p).grep(*.name == $m_name);
	}
	X::Overload::Missing.new(:type($pkg), :method($m)).throw;

}

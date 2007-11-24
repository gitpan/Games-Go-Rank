package Games::Go::Rank;

use warnings;
use strict;


our $VERSION = '0.04';


use base 'Class::Accessor::Complex';


use overload
    '""'  => 'stringify',
    '<=>' => 'num_cmp';


__PACKAGE__
    ->mk_new
    ->mk_accessors(qw(rank));


sub stringify {
    my $self = shift;
    $self->rank;
}


sub as_value {
    my $self = shift;
    my $rank = $self->rank;
    return unless defined $rank;   # so m// doesn't complain

    if    ($rank =~ /^\s*(\d+)[\s-]*k/) { return -$1 + 1 }
    elsif ($rank =~ /^\s*(\d+)[\s-]*d/) { return  $1     }
    elsif ($rank =~ /^\s*(\d+)[\s-]*p/) { return  $1 + 7 }
    else                                { return         }
}


sub from_value {
    my ($self, $value) = @_;
    if ($value <= 0) {
        $self->rank(sprintf "%sk" => -$value + 1)
    } elsif ($value > 0 && $value <= 7) {
        $self->rank(sprintf "%sd" => $value)
    } elsif ($value > 7) {
        $self->rank(sprintf "%sp" => $value - 7)
    } else {
        $self->clear_rank;
    }
    return $self;
}


sub num_cmp {
    my ($lhs, $rhs, $reversed) = @_;
    for ($lhs, $rhs) {
        if (ref $_ eq __PACKAGE__) {
            $_ = $_->as_value;
        } else {
            $_ = __PACKAGE__->new(rank => $_)->as_value;
        }
    }
    ($lhs, $rhs) = ($rhs, $lhs) if $reversed;
    for ($lhs, $rhs) { $_ = -99 unless defined($_) }
    $lhs <=> $rhs;
}


1;


__END__



=head1 NAME

Games::Go::Rank - represents a player's rank in the game of Go

=head1 SYNOPSIS

    use Games::Go::Rank;

    my $black_rank = Games::Go::Rank->new(rank => '1k');
    my $white_rank = Games::Go::Rank->new(rank => '2d');
    if ($white_rank > $black_rank) { ... }

=head1 DESCRIPTION

This class represents a player's rank in the game of Go. Rank objects can be
compared to see whether two ranks are equal or whether one rank is higher than
the other. Rank objects stringify to the rank notation.

Use the standard notation for ranks such as C<30k>, C<5k>, C<1d>, C<2p> and so
on. You can also use other common formats such as C<6-dan> or C<2 dan>.
Anything after the first C<k>, C<d> or C<p> is ignored. So C<6-dan*> is the
same as C<6-dan>, which is the same as C<6d>.

Games::Go::Rank inherits from L<Class::Accessor::Complex>.

The superclass L<Class::Accessor::Complex> defines these methods and
functions:

    carp(), cluck(), croak(), flatten(), mk_abstract_accessors(),
    mk_array_accessors(), mk_boolean_accessors(),
    mk_class_array_accessors(), mk_class_hash_accessors(),
    mk_class_scalar_accessors(), mk_concat_accessors(),
    mk_forward_accessors(), mk_hash_accessors(), mk_integer_accessors(),
    mk_new(), mk_object_accessors(), mk_scalar_accessors(),
    mk_set_accessors(), mk_singleton()

The superclass L<Class::Accessor> defines these methods and functions:

    _carp(), _croak(), _mk_accessors(), accessor_name_for(),
    best_practice_accessor_name_for(), best_practice_mutator_name_for(),
    follow_best_practice(), get(), make_accessor(), make_ro_accessor(),
    make_wo_accessor(), mk_accessors(), mk_ro_accessors(),
    mk_wo_accessors(), mutator_name_for(), set()

The superclass L<Class::Accessor::Installer> defines these methods and
functions:

    install_accessor(), subname()

=head1 METHODS

=over 4

=item new

    my $obj = Games::Go::Rank->new;
    my $obj = Games::Go::Rank->new(%args);

Creates and returns a new object. The constructor will accept as arguments a
list of pairs, from component name to initial value. For each pair, the named
component is initialized by calling the method of the same name with the given
value. If called with a single hash reference, it is dereferenced and its
key/value pairs are set as described before.

=item as_value

Returns a number representing the rank. C<1k> is returned as C<0>, lower kyu
ranks are returned as negative numbers (C<2K> is C<-1>, C<3k> is C<-2> etc.).
Dan ranks are returned as positive numbers, with pro ranks coming immediately
after dan ranks. For example, C<1d> == C<1>, C<7d> == C<7>, C<1p> == C<8>,
C<2p> == C<9>. Only dan ranks up to 7d are recognized as amateur ranks -
that is, C<8d> == C<1p>.

=item from_value

Sets the rank from a numerical value that is interpreted as described above.

=back

=head1 TAGS

If you talk about this module in blogs, on del.icio.us or anywhere else,
please use the C<gamesgorank> tag.

=head1 VERSION 
                   
This document describes version 0.04 of L<Games::Go::Rank>.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<<bug-games-go-rank@rt.cpan.org>>, or through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit <http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see <http://www.perl.com/CPAN/authors/id/M/MA/MARCEL/>.

=head1 AUTHOR

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2007 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut


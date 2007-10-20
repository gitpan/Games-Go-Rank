package Games::Go::Rank;

use warnings;
use strict;


our $VERSION = '0.01';


use base 'Class::Accessor::Complex';


use overload
    '""'  => 'stringify',
    '<=>' => 'num_cmp';


Games::Go::Rank
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

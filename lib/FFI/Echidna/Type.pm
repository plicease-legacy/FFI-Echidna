use strict;
use warnings;
use 5.020;
use experimental qw( signatures postderef );

package FFI::Echidna::Type {

  # ABSTRACT: Moose types for FFI::Echidna
  
  use Moose::Util::TypeConstraints;
  use MooseX::Getopt ();
  use Import::Into;
  use namespace::autoclean;

  sub import
  {
    my $types;
      
    unless($types) {
      push $types->@*, 
        subtype('FFI::Echidna::Type::RegexpRef' => as 'RegexpRef'),
        subtype('FFI::Echidna::Type::DirList' => as 'ArrayRef[Path::Class::Dir]'),
        subtype('FFI::Echidna::Type::FileList' => as 'ArrayRef[Path::Class::File]'),
      ;

      coerce 'FFI::Echidna::Type::RegexpRef'
      => from 'Str'
      => via { qr{$_} };
    
      coerce 'FFI::Echidna::Type::DirList'
      => from 'ArrayRef[Str]'
      => via { [map { Path::Class::Dir->new($_) } $_->@*] };

      coerce 'FFI::Echidna::Type::FileList'
      => from 'ArrayRef[Str]'
      => via { [map { Path::Class::File->new($_) } $_->@*] };
    
      MooseX::Getopt::OptionTypeMap->add_option_type_to_map(
        'FFI::Echidna::Type::RegexpRef' => '=s',
      );
    }
      
    my $caller = caller;
    foreach my $type ($types->@*)
    {
      constant->import::into($caller, ($type->name =~ s{^.*::}{}r) => $type);
    }
  }
    
}

1;

__END__

=head1 DESCRIPTION

Private class for use by FFI::Platypus.

=head1 SEE ALSO

=over 4

=item L<h2ffi>

=item L<FFI::Platypus>

=back

=cut

#!/usr/bin/env perl

use lib 't/lib';
use Test::Most;
use DBIx::Class::Migration;
use DBIx::Class::Migration::RunScript;
use DBIx::Class::Migration::RunScript::Trait::AuthenPassphrase;
use File::Spec::Functions 'catfile';
use File::Path 'rmtree';


ok(
  my $migration = DBIx::Class::Migration->new(schema_class=>'Local::Schema'),
  'created migration with schema_class');

$migration->prepare;
$migration->install;

my $code = migrate {
  my $runscript = shift;
  ok $runscript->can('authen_passphrase'), 'Got authen_passphrase';
};
  
ok $code->($migration->schema, [1,2]);

done_testing;

END {
  rmtree catfile($migration->target_dir, 'migrations');
  rmtree catfile($migration->target_dir, 'fixtures');
  unlink catfile($migration->target_dir, 'local-schema.db');
}

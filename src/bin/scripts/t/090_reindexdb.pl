use strict;
use warnings;
use TestLib;
use Test::More tests => 18;

program_help_ok('reindexdb');
program_version_ok('reindexdb');
program_options_handling_ok('reindexdb');

my $tempdir = tempdir;
start_test_server $tempdir;

$ENV{PGOPTIONS} = '--client-min-messages=WARNING';

issues_sql_like(
	[ 'reindexdb', 'postgres' ],
	qr/statement: REINDEX DATABASE postgres;/,
	'SQL REINDEX run');

psql 'postgres',
  'CREATE TABLE test1 (a int); CREATE INDEX test1x ON test1 (a);';
issues_sql_like(
	[ 'reindexdb', '-t', 'test1', 'postgres' ],
	qr/statement: REINDEX TABLE test1;/,
	'reindex specific table');
issues_sql_like(
	[ 'reindexdb', '-i', 'test1x', 'postgres' ],
	qr/statement: REINDEX INDEX test1x;/,
	'reindex specific index');
issues_sql_like(
	[ 'reindexdb', '-S', 'pg_catalog', 'postgres' ],
	qr/statement: REINDEX SCHEMA pg_catalog;/,
	'reindex specific schema');
issues_sql_like(
	[ 'reindexdb', '-s', 'postgres' ],
	qr/statement: REINDEX SYSTEM postgres;/,
	'reindex system tables');

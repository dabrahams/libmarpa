# Copyright 2013 Jeffrey Kegler
# This file is part of Marpa::R2.  Marpa::R2 is free software: you can
# redistribute it and/or modify it under the terms of the GNU Lesser
# General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Marpa::R2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser
# General Public License along with Marpa::R2.  If not, see
# http://www.gnu.org/licenses/.

use 5.010;
use strict;
use warnings;
use Carp;
use English qw( -no_match_vars );

our $HEADER;

sub offset {
    my ($desc) = @_;
    my @fields = split q{ }, $desc;
    my $offset     = -1;
    my $in_comment = 0;

    no strict 'refs';
    FIELD: for my $field (@fields) {

        if ($in_comment) {
            $in_comment = $field ne ':}' && $field ne '}';
            next FIELD;
        }

        PROCESS_OPTION: {
            last PROCESS_OPTION if $field !~ /\A [{:] /xms;
            if ( $field =~ / \A [:] package [=] (.*) /xms ) {
		say "\npackage $1;";
		$offset = -1;
                next FIELD;
            }
            if ( $field =~ / \A [:]? [{] /xms ) {
                $in_comment++;
                next FIELD;
            }
        } ## end PROCESS_OPTION:


	if ((substr $field, 0, 1) eq '=') {
	    $field = substr $field, 1;
	} else {
	    $offset++;
	}
	die "Unacceptable field name: $field"
	      if $field =~ /[^A-Z0-9_]/xms;
	say "use constant $field => $offset;"

    } ## end for my $field (@fields)
    return 1;
} ## end sub Marpa::R2::offset

$HEADER =~ s/!!!PROGRAM_NAME!!!/$PROGRAM_NAME/;
say $HEADER;
$RS = undef;
offset(<DATA>);
say "\n1;";

BEGIN {

$HEADER = <<'END_OF_HEADER';
# Copyright 2013 Jeffrey Kegler
# This file is part of Marpa::R2.  Marpa::R2 is free software: you can
# redistribute it and/or modify it under the terms of the GNU Lesser
# General Public License as published by the Free Software Foundation,
# either version 3 of the License, or (at your option) any later version.
#
# Marpa::R2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser
# General Public License along with Marpa::R2.  If not, see
# http://www.gnu.org/licenses/.

# DO NOT EDIT THIS FILE DIRECTLY
# It was generated by !!!PROGRAM_NAME!!!

package Marpa::R2::Internal;

use 5.010;
use strict;
use warnings;
use Carp;

use vars qw($VERSION $STRING_VERSION);
$VERSION        = '2.069_003';
$STRING_VERSION = $VERSION;
$VERSION = eval $VERSION;
END_OF_HEADER

}

__DATA__

    :package=Marpa::R2::Internal::Symbol
    ID { Unique ID }
    BLESSING
    LEXEME_SEMANTICS
    DISPLAY_FORM
    DSL_FORM
    LEGACY_NAME
    DESCRIPTION

    :package=Marpa::R2::Internal::Rule

    ID
    NAME
    DISCARD_SEPARATION
    MASK { Semantic mask of RHS symbols }
    ACTION_NAME
    BLESSING
    DESCRIPTION

    :package=Marpa::R2::Internal::Grammar

    C { A C structure }
    TRACER { Also contains a copy of the C structure.
       It is used frequently, so that an easy memoization
       is probably worthwhile to save a the extra
       indirection.
    }
    RULES { array of rule refs }
    DESCRIPTION_BY_RULE

    SYMBOLS { array of symbol refs }

    ACTIONS { Default package in which to find actions }
    BLESS_PACKAGE { Default package into which nodes are blessed }
    DEFAULT_ACTION { Action for rules without one }
    TRACE_FILE_HANDLE
    WARNINGS { print warnings about grammar? }
    RULE_NAME_REQUIRED
    RULE_BY_NAME
    INTERFACE { currently 'standard' or 'stuifzand' }
    INTERNAL { internal grammar -- relax various restrictions }

    CHARACTER_CLASSES { an hash of
    character class regex by symbol name.
    Used before precomputation. }

    CHARACTER_CLASS_TABLE { An array of symbol ID and
    regex.  Used after precomputation. }

    =LAST_BASIC_DATA_FIELD

    { === Evaluator Fields === }

    DEFAULT_EMPTY_ACTION { default value for empty rules }
    ACTION_OBJECT
    INFINITE_ACTION

    =LAST_EVALUATOR_FIELD

    PROBLEMS { fatal problems }

    =LAST_RECOGNIZER_FIELD

    START_NAME { name of original symbol }
    INACCESSIBLE_OK
    UNPRODUCTIVE_OK
    TRACE_RULES

    =LAST_FIELD

    :package=Marpa::R2::Internal::Recognizer

    C { C structure for the recognizer }
    B_C { C structure for the bocage }
    O_C { C structure for the Marpa order object }
    T_C { C structure for the Marpa tree iterator }

    GRAMMAR { the grammar used }
    TREE_MODE { 'tree' or 'forest' or undef }
    FINISHED
    TOKEN_VALUES

    ASF_OR_NODES { memoized or-nodes }

    TRACE_FILE_HANDLE

    END_OF_PARSE
    CLOSURES
    EVENT_IF_EXPECTED
    MAX_PARSES
    RANKING_METHOD
    TRACE_ACTIONS
    TRACE_AND_NODES
    TRACE_BOCAGE
    TRACE_EARLEY_SETS
    TRACE_OR_NODES
    TRACE_TASKS
    TRACE_TERMINALS
    TRACE_VALUES
    TRACE_SL
    WARNINGS

    { The following fields must be reinitialized when
    evaluation is reset }

    EVENTS
    READ_STRING_ERROR
    NULL_VALUES

    { Fields for new SLIF resolution logic
    -- must be reinitialized when evaluation is reset }
    PER_PARSE_CONSTRUCTOR
    RESOLVE_PACKAGE
    RESOLVE_PACKAGE_SOURCE
    REGISTRATIONS
    CLOSURE_BY_SYMBOL_ID
    CLOSURE_BY_RULE_ID

    { This is the end of the list of fields which
    must be reinitialized when evaluation is reset }

    :package=Marpa::R2::Internal::Progress_Report

    RULE_ID
    POSITION
    ORIGIN
    CURRENT

    :package=Marpa::R2::Internal::Scanless::Choicepoint

    OR_NODE_IDS { array of the or-node IDs }
    TOKEN_IDS { array of the token IDs }
    EXTERNAL { boolean: should this choicepoint be visible outside the ASF code? }

    { One of the or-node and token ID array will be non-empty.
      Currently only one will be non-empty, but this may change if
      the SLIF implements LHS terminals. }

    :package=Marpa::R2::Internal::Scanless::ASF

    SLR { The underlying SLR }
    CHOICE_BLESSING
    RULE_BLESSING
    SYMBOL_BLESSING
    CHOICEPOINT_IS_FACTORED

    { FAC_ indicates fields which would belong to separate factoring
     object, if there was one }
    FAC_CHAF_PREDECESSOR_BY_CAUSE
    FAC_CHAF_CAUSE_IS_ACTIVE

    CHOICEPOINTS_BY_TOKEN_ID
    CHOICEPOINTS_BY_OR_NODE_ID

    :package=Marpa::R2::Internal::Scanless::ASF2

    { Temporary old version of ASF -- to be deleted }
    SLR { The underlying SLR }
    CHOICE_BLESSING
    RULE_BLESSING
    SYMBOL_BLESSING
    CHOICEPOINT_IS_FACTORED

    { FAC_ indicates fields which would belong to separate factoring
     object, if there was one }
    FAC_CHAF_PREDECESSOR_BY_CAUSE
    FAC_CHAF_CAUSE_IS_ACTIVE

    CHOICEPOINTS_BY_TOKEN_ID
    CHOICEPOINTS_BY_OR_NODE_ID

    :package=Marpa::R2::Inner::Scanless::G

    C { The thin version of this object }

    THICK_LEX_GRAMMAR
    THICK_G1_GRAMMAR
    CHARACTER_CLASS_TABLE
    G0_RULE_TO_G1_LEXEME
    G0_DISCARD_SYMBOL_ID
    MASK_BY_RULE_ID

    G1_ARGS
    DEFAULT_G1_START_ACTION
    COMPLETION_EVENT_BY_ID
    NULLED_EVENT_BY_ID
    PREDICTION_EVENT_BY_ID
    LEXEME_EVENT_BY_ID
    TRACE_FILE_HANDLE
    BLESS_PACKAGE
    SYMBOL_IDS_BY_EVENT_NAME_AND_TYPE

    { This saves a lot of time at points }
    CACHE_RULEIDS_BY_LHS_NAME

    :package=Marpa::R2::Inner::Scanless::R

    C { The thin version of this object }

    GRAMMAR
    THICK_G1_RECCE
    P_INPUT_STRING

    TRACE_FILE_HANDLE
    TRACE_G0
    TRACE_TERMINALS
    READ_STRING_ERROR
    EVENTS


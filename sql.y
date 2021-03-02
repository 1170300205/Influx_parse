%{
	#include <stdlib.h>
	#include "sql.h"

	
	
	extern "C" {
		
	void yyerror(const char *s);
	extern int yylex(void);
		
	}
	
	
%}	


%union {
	SqlNodeType* pNode;
}

%token STMT
%token OP ST NSPLIT ST_LIST
%token FM NAME FM_LIST NAME_LIST
%token WH WHSPLIT WH_LIST WHNAME_LIST WHNAME
%token OPERATOR LBORDER RBORDER ORDER GROUP
%token TERMINATOR MEASURE
%token STRING INTEGER FLOAT REGEX 
%token INTO LIMIT OFFSET SLMIT SOFFSET TZ AS ASC DESC OP DELETE ON
%token LEFTPARENTHESIS RIGHTPARENTHESIS DURATION BOOL FILLS FILL MEASURE
%token FIELD_KEY DURA REPLICATION SHARD CNAME DEFAULT ALTER
%token DB_NAME POLICY_NAME MEASUREMENT_NAME UNARY_EXPR DURATION_LIT EXPR
%token DIMENSION DIMENSIONS FIELD FIELDS FILL_OPTION FILL_CLAUSE
%token MEASUREMENT MEASUREMENTS VAR_REF BACK_REF SORT_FIELD SORT_FIELDS GROUP_BY_CLAUSE ORDER_BY_CLAUSE 
%token TIMEZONE_CLAUSE INTO_CLAUSE WHERE_CLAUSE ALIAS FROM_CLAUSE SEL_CLAUSE
%token LIMIT_CLAUSE OFFSET_CLAUSE SLMIT_CLAUSE SOFFSET_CLAUSE DELETE_STMT ON_CLAUSE RETENTION_POLICY_OPTION ALTER_STMT
 
%type<pNode> STMT
%type<pNode> OP ST NSPLIT ST_LIST
%type<pNode> FM NAME FM_LIST NAME_LIST
%type<pNode> WH WHSPLIT WH_LIST WHNAME_LIST WHNAME
%type<pNode> OPERATOR LBORDER RBORDER ORDER GROUP
%type<pNode> TERMINATOR MEASURE
%type<pNode> STRING INTEGER FLOAT REGEX
%type<pNode> INTO LIMIT OFFSET SLMIT SOFFSET TZ AS ASC DESC OP DELETE ON
%type<pNode> LEFTPARENTHESIS RIGHTPARENTHESIS DURATION BOOL FILLS FILL MEASURE
%type<pNode> FIELD_KEY DURA REPLICATION SHARD CNAME DEFAULT ALTER
%type<pNode> DB_NAME POLICY_NAME MEASUREMENT_NAME UNARY_EXPR DURATION_LIT EXPR
%type<pNode> DIMENSION DIMENSIONS FIELD FIELDS FILL_OPTION FILL_CLAUSE
%type<pNode> MEASUREMENT MEASUREMENTS VAR_REF BACK_REF SORT_FIELD SORT_FIELDS GROUP_BY_CLAUSE ORDER_BY_CLAUSE 
%type<pNode> TIMEZONE_CLAUSE INTO_CLAUSE WHERE_CLAUSE ALIAS FROM_CLAUSE SEL_CLAUSE
%type<pNode> LIMIT_CLAUSE OFFSET_CLAUSE SLMIT_CLAUSE SOFFSET_CLAUSE DELETE_STMT ON_CLAUSE RETENTION_POLICY_OPTION ALTER_STMT

%type<pNode> program stmt st_list fm_list wh_list name_list whname_list whname limit_clause offset_clause slimit_clause soffset_clause whvalue field_key on_clause alter_stmt
%type<pNode> measurement measurements var_ref back_ref sort_field sort_fields group_by_clause order_by_clause timezone_clause into_clause where_clause alias from_clause sel_clause
%type<pNode> dimension dimensions field fields fill_option fill_clause db_name policy_name measurement_name unary_expr duration_lit expr delete_stmt on_clause retention_policy_option
%%

program:
sel_clause TERMINATOR {ProcessTree($1);}
|delete_stmt TERMINATOR {ProcessTree($1);}
|alter_stmt TERMINATOR {ProcessTree($1);}
;    

stmt:
st_list fm_list                     {$$ = NewFatherAddSon(STMT, $1, $2);}
|st_list fm_list wh_list           {$$ = NewFatherAddSon(STMT, $1, $2, $3);}
;

st_list:
ST name_list                    {$$ = NewFatherAddSon(ST_LIST, $1, $2);}
;

fm_list:
FM NAME                         {$$ = NewFatherAddSon(FM_LIST, $1, $2);}
;

wh_list:
WH whname_list                  {$$ = NewFatherAddSon(WH_LIST, $1, $2);}
;

name_list:
NAME                           {$$ = NewFatherAddSon(NAME_LIST, $1);}
|name_list NAME          	   {$$ = FatherAddSon($1, $2);}
;

whname_list:
whname                          {$$ = NewFatherAddSon(WHNAME_LIST, $1);}
|whname_list WHSPLIT whname     {FatherAddSon($1, $2); $$ = FatherAddSon($1, $3);}
;

whname:
NAME OPERATOR whvalue          {$$ = NewFatherAddSon(WHNAME, $1, $2, $3);}
;


delete_stmt:
DELETE from_clause					{$$ = NewFatherAddSon(DELETE_STMT, $1, $2);}
|DELETE where_clause 				{$$ = NewFatherAddSon(DELETE_STMT, $1, $2);}
|DELETE from_clause where_clause	{$$ = NewFatherAddSon(DELETE_STMT, $1, $2, $3);}
;

sel_clause:
ST fields from_clause						{$$ = NewFatherAddSon(SEL_CLAUSE, $1, $2);}
|ST fields from_clause where_clause			{$$ = NewFatherAddSon(SEL_CLAUSE, $1, $2, $3);}
|ST fields from_clause group_by_clause		{$$ = NewFatherAddSon(SEL_CLAUSE, $1, $2, $3);}
|ST fields from_clause order_by_clause		{$$ = NewFatherAddSon(SEL_CLAUSE, $1, $2, $3);}
|ST fields from_clause into_clause			{$$ = NewFatherAddSon(SEL_CLAUSE, $1, $2, $3);}
|ST fields from_clause offset_clause		{$$ = NewFatherAddSon(SEL_CLAUSE, $1, $2, $3);}
|ST fields from_clause limit_clause			{$$ = NewFatherAddSon(SEL_CLAUSE, $1, $2, $3);}
|ST fields from_clause slimit_clause		{$$ = NewFatherAddSon(SEL_CLAUSE, $1, $2, $3);}
|ST fields from_clause timezone_clause		{$$ = NewFatherAddSon(SEL_CLAUSE, $1, $2, $3);}
;	


alter_stmt:
ALTER policy_name on_clause retention_policy_option 	{$$ = NewFatherAddSon(ALTER_STMT, $1, $2, $3, $4);}

from_clause:
FM measurements					{$$ = NewFatherAddSon(FROM_CLAUSE, $1, $2);}
;

alias: 
AS NAME							{$$ = NewFatherAddSon(ALIAS, $1, $2);}
;

where_clause:
WH expr							{$$ = NewFatherAddSon(WHERE_CLAUSE, $1, $2)}
;

into_clause:
INTO measurement				{$$ = NewFatherAddSon(INTO_CLAUSE, $1, $2);}
INTO back_ref					{$$ = NewFatherAddSon(INTO_CLAUSE, $1, $2);}
;

timezone_clause:
TZ LEFTPARENTHESIS STRING RIGHTPARENTHESIS  {$$ = NewFatherAddSon(TIMEZONE_CLAUSE, $1, $2, $3, $4);}
;

limit_clause:
LIMIT INTEGER					{$$ = NewFatherAddSon(LIMIT_CLAUSE, $1, $2);}
;

offset_clause:
OFFSET INTEGER 				    {$$ = NewFatherAddSon(OFFSET_CLAUSE, $1, $2);}
;

slimit_clause:					
SLMIT INTEGER					{$$ = NewFatherAddSon(SLMIT_CLAUSE, $1, $2);}
;

soffset_clause:
SOFFSET INTEGER                 {$$ = NewFatherAddSon(SOFFSET_CLAUSE, $1, $2);}
;

order_by_clause:
ORDER sort_fields				{$$ = NewFatherAddSon(ORDER_BY_CLAUSE, $1, $2);}
;

group_by_clause:
GROUP dimensions fill_clause    {$$ = NewFatherAddSon(GROUP_BY_CLAUSE, $1, $2, $3);}
;

sort_fields:
sort_field						{$$ = NewFatherAddSon(SORT_FIELDS, $1);}
|sort_fields NSPLIT sort_field  {$$ = FatherAddSon($1, $3);}
;

sort_field:         			
field_key 						{$$ = NewFatherAddSon(SORT_FIELD, $1);}
|field_key ASC					{$$ = NewFatherAddSon(SORT_FIELD, $1, $2);}
|field_key DESC					{$$ = NewFatherAddSon(SORT_FIELD, $1, $2);}
;

back_ref:
policy_name MEASURE   			{$$ = NewFatherAddSon(BACK_REF, $1, $2);}
db_name '.' policy_name MEASURE {$$ = NewFatherAddSon(BACK_REF, $1, $3, $4);}
;

var_ref:
measurement						{$$ = NewFatherAddSon(VAR_REF, $1);}

measurements:
measurement						 {$$ = NewFatherAddSon(MEASUREMENTS, $1);}
|measurements NSPLIT measurement {$$ = FatherAddSon($1, $3);}
;

measurement:
measurement_name                {$$ = NewFatherAddSon(MEASUREMENT, $1);}
policy_name '.' measurement_name {$$ = NewFatherAddSon(MEASUREMENT, $1, $3);}
db_name '.' policy_name '.' measurement_name  {NewFatherAddSon(MEASUREMENT, $1, $3, $5);}
;


retention_policy_option:
DURA duration_lit				{$$ = NewFatherAddSon(RETENTION_POLICY_OPTION, $1, $2);}
|REPLICATION INTEGER			{$$ = NewFatherAddSon(RETENTION_POLICY_OPTION, $1, $2);}
|SHARD duration_lit				{$$ = NewFatherAddSon(RETENTION_POLICY_OPTION, $1, $2);}
|DEFAULT						{$$ = NewFatherAddSon(RETENTION_POLICY_OPTION, $1);}



fill_clause:
FILL LEFTPARENTHESIS fill_option RIGHTPARENTHESIS   {$$ = NewFatherAddSon(FILL_CLAUSE, $1, $2, $3, $4);}
;

fill_option:
FILLS							{$$ = NewFatherAddSon(FILL_OPTION, $1);}
|INTEGER						{$$ = NewFatherAddSon(FILL_OPTION, $1);}
|FLOAT							{$$ = NewFatherAddSon(FILL_OPTION, $1);}
;

fields:
field							{$$ = NewFatherAddSon(FIELDS, $1);}
|fields NSPLIT field            {$$ = NewFatherAddSon(FIELDS, $1, $2, $3);}
;

field:
expr							{$$ = NewFatherAddSon(FIELD, $1);}
|expr alias						{$$ = NewFatherAddSon(FIELD, $1, $2);}

dimensions:
dimension						{$$ = NewFatherAddSon(DIMENSIONS, $1);}
dimensions NSPLIT dimension     {$$ = NewFatherAddSon(DIMENSIONS, $1, $2, $3);}
;

dimension:
expr							{$$ = NewFatherAddSon(DIMENSION, $1);}
;

expr:
unary_expr						{$$ = NewFatherAddSon(EXPR, $1);}
|expr WHSPLIT unary_expr		{$$ = NewFatherAddSon(EXPR, $1, $2, $3);}
;

duration_lit:
INTEGER DURATION    			{$$ = NewFatherAddSon(DURATION_LIT, $1, $2);}
;

unary_expr:
INTEGER							{$$ = NewFatherAddSon(UNARY_EXPR, $1);}
|FLOAT							{$$ = NewFatherAddSon(UNARY_EXPR, $1);}
|REGEX							{$$ = NewFatherAddSon(UNARY_EXPR, $1);}
|BOOL							{$$ = NewFatherAddSon(UNARY_EXPR, $1);}
|duration_lit					{$$ = NewFatherAddSon(UNARY_EXPR, $1);}
|var_ref						{$$ = NewFatherAddSon(UNARY_EXPR, $1);}
|STRING							{$$ = NewFatherAddSon(UNARY_EXPR, $1);}
|LEFTPARENTHESIS expr RIGHTPARENTHESIS  {$$ = NewFatherAddSon(UNARY_EXPR, $1, $2, $3);}
;

on_clause:
ON db_name						{$$ = NewFatherAddSon(ON_CLAUSE, $1, $2);}

field_key:
NAME							{$$ = $1;}
;

measurement_name:
NAME							{$$ = $1;}
|REGEX							{$$ = $1;}
;

policy_name:
NAME							{$$ = $1;}
;

db_name:
NAME							{$$ = $1;}
;

whvalue:
NAME                              {$$ = $1;}
|INTEGER                          {$$ = $1;}
|FLOAT						      {$$ = $1;}
;


%%

void yyerror(const char *s)
{
	printf("Error: %s\n", s);
}

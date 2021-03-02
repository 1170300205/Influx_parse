%{
   #include "sql.h"
   #include "y.tab.h"

   extern "C" {

   int yylex(void);

   }

%}

integer         [-]?[1-9][0-9]+
float           [-]?[0-9]+(\.[0-9]+)
string          [\'][_0-9a-zA-Z\(\)\.\*]*[\']
regex           [\/][_0-9a-zA-Z\(\)\.\*]*[\/]
name            [\"]?[_a-zA-Z][_0-9a-zA-Z\(\)\.\*]*[\"]?
whitespace      [ \n\t]
as              (As|AS|as)
st              (select|SELECT|Select)
fm              (from|FROM|From)
wh              (where|WHERE|Where)
delete          (delete|Delete|DELETE)
asc             (ASC)
desc            (DESC)
on				(on|ON|On)
into            (into|INTO|Into)
limit           (limit|LIMIT|Limit)
offset          (offset|OFFSET|Offset)
slmit           (slmit|SLMIT|Slmit)
soffset         (soffset|SOFFSET|Soffset)
group           ((group by)|(GROUP BY))
order           ((order by)|(ORDER BY))
dura			(DURATION)
replication     (REPLICATION)
shard			(SHARD DURATION)
cname			(NAME)
default			(DEFAULT)
alter			(ALTER RETENTION POLICY)
measure         (\.:MEASUREMENT)
terminator      [;]
nsplit          [,]
duration        (u|µ|ms|s|m|h|d|w)
whsplit         (and|AND|or|OR|Or|And)
bool            (TRUE|FALSE)
fills           (null|none|previous|linear)
fill            (fill)
op              [(\+)|(-)|(*)|(&)|(%)|(\^)|(\/)|(\|)]
operator        [(<)|(>)|(=)|(<=)|(>=)|(!=)|(<>)]
leftparenthesis [\(]
rightparenthesis [\)]
tz              (tz)

%%
   
{st}  	{
                yylval.pNode = MallocNewNode();
                yylval.pNode->type=ST;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"select");
                return ST;
        }

{delete}  	{
                yylval.pNode = MallocNewNode();
                yylval.pNode->type=DELETE;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"delete");
                return DELETE;
        }
		
{asc}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=ASC;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"ASC");
                return ASC;
		}
		
{desc}  {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=DESC;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"DESC");
                return DESC;
		}

{fm}    {
                yylval.pNode = MallocNewNode();
                yylval.pNode->type=FM;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"from");
                return FM;
        }

{wh}    {
                yylval.pNode = MallocNewNode();
                yylval.pNode->type=WH;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"where");
                return WH;
        }

{on}    {
                yylval.pNode = MallocNewNode();
                yylval.pNode->type=ON;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"on");
                return ON;
        }
		
{into}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=INTO;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"into");
                return INTO;
		}
		
{limit}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=LIMIT;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"limit");
                return LIMIT;
		}
		
{offset}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=OFFSET;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"offset");
                return OFFSET;
			}

{slmit}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=SLMIT;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"slmit");
                return SLMIT;
		}
		
{group} {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=GROUP;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"group by");
                return GROUP;
		}
		
{order} {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=ORDER;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"order by");
                return ORDER;
		}

{alter} {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=ALTER;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"ALTER RETENTION POLICY");
                return ALTER;
		}		

{dura} {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=DURA;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"DURATION");
                return DURA;
		}
		
{replication} {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=REPLICATION;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"REPLICATION");
                return REPLICATION;
			}
			
{shard} {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=SHARD;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"SHARD DURATION");
                return SHARD;
		}
		
{cname} {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=CNAME;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"NMAE");
                return CNAME;
		}
		
{default} {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=DEFAULT;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"DEFAULT");
                return DEFAULT;
		}
		
{tz}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=TZ;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"tz");
                return TZ;
		}
		
{as}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=AS;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"as");
                return AS;
		}
		
{measure}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=AS;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),".:MEASUREMENT");
                return MEASURE;
			}

{op}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=OP;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
                return OP;
		}

{whsplit} {
                yylval.pNode = MallocNewNode();
                yylval.pNode->type=WHSPLIT;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
                return WHSPLIT;
          }

{operator} {
                yylval.pNode = MallocNewNode();
                yylval.pNode->type= OPERATOR;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
                return OPERATOR;
           }
		 
{leftparenthesis} 	{
						yylval.pNode = MallocNewNode();
						yylval.pNode->type= LEFTPARENTHESIS;
						snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
						return LEFTPARENTHESIS;
					}
					
{rightparenthesis}	{
						yylval.pNode = MallocNewNode();
						yylval.pNode->type= RIGHTPARENTHESIS;
						snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
						return RIGHTPARENTHESIS;
					}

{nsplit}       ;

{duration}		{
						yylval.pNode = MallocNewNode();
						yylval.pNode->type= DURATION;
						snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
						return DURATION;
				}
				
{bool}			{
						yylval.pNode = MallocNewNode();
						yylval.pNode->type= BOOL;
						snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
						return BOOL;
				}
				
{fills}         {
						yylval.pNode = MallocNewNode();
						yylval.pNode->type= FILLS;
						snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
						return FILLS;
				}
				
{fill}			{
						yylval.pNode = MallocNewNode();
						yylval.pNode->type= FILL;
						snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
						return FILL;
				}

{name}         {
                yylval.pNode = MallocNewNode();
                yylval.pNode->type=NAME;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
                return NAME;
               }
			   
{string}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=STRING;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
                return STRING;
			}
			
{regex}	{
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=REGEX;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
                return REGEX;
			}

{integer}   {
                yylval.pNode = MallocNewNode();
                yylval.pNode->type=INTEGER;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
                return INTEGER;
			}
			
{float}     {
				yylval.pNode = MallocNewNode();
                yylval.pNode->type=FLOAT;
                snprintf(yylval.pNode->text,sizeof(yylval.pNode->text),"%s",yytext);
                return FLOAT;
			}

{terminator}    {
                        return TERMINATOR;
                }

{whitespace}    ;

.            ;

%%

int main()
{
    
	return 0;
}





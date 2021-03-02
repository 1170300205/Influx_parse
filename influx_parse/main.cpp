#include <iostream>
#include <bits/stdc++.h>
#include "db.h"

using namespace std;

//QuasDB::Status status = QuasDB::DB::Open(options, "/tmp/testdb", &db);

vector<string> split(const string& str, const string& delim)
{
    vector<string> res;
    if("" == str)
        return res;
    //先将要切割的字符串从string类型转换为char*类型
    char * strs = new char[str.length() + 1] ; //不要忘了
    strcpy(strs, str.c_str());

    char * d = new char[delim.length() + 1];
    strcpy(d, delim.c_str());

    char *p = strtok(strs, d);
    while(p)
    {
        string s = p; //分割得到的字符串转换为string类型
        res.push_back(s); //存入结果数组
        p = strtok(NULL, d);
    }
    return res;
}

bool icasecompare(const string& s1, const string& s2)
{
    return (stricmp(s1.c_str(), s2.c_str()) == 0);
}

void parse(const string& s, QuasDB::Status status, QuasDB::DB *db)
{
    vector<string> text = split(s," ");
    std::string str = text[0];
    if(icasecompare(str,"select"))
    {
        int i = 1;
        std::string db_name;
        int cn1,cn2;
        while(i < text.size())
        {
            std::string s = text[i];
            if (icasecompare(s, "") || icasecompare(s," "))
            {
                continue;
            }
            else if(icasecompare(s, "from"))
            {
                cn1 = i;
                db_name = text[cn1+1];
            }
            else if(icasecompare(s, "where"))
            {
                cn2 = i;
            }
            i++;
        }   //cout << "select" << endl;
        for(int j = 1; j < cn1; j++)
        {
            status = db->Get(QuasDB::ReadOptions(), text[j], &text[cn2+1]);
        }

    }
    else if(icasecompare(str, "delete"))
    {
        int i = 1;
        bool flag = false;
        for(int j = 1; j < text.size(); j++)
        {
            std::string s = text[i];
            if (icasecompare(s, "where"))
            {
                flag = true;
            }
        }
        if(!flag)
            while(i < text.size())
            {
                String s = text[i];
                if (icasecompare(s, "") || icasecompare(s," "))
                {
                    continue;
                }
                else if(icasecompare(s,"from"))
                {
                    i++;
                    std::string db_name = text[i];
                }
                else if(icasecompare(s,"where"))
                {
                    i++;
                    std::string key = text[i];
                    status = db->Delete(QuasDB::WriteOptions(), key);
                    //delete(key);
                }
                i++;
            }
    }
    else if(icasecompare(str, "alter"))
    {
        int i = 1;
        while(i < text.size())
        {
            String s = text[i];
            if (s.equals(" ") || s.equals(""))
            {
                continue;
            }
            else if(s.equalsIgnoreCase("on"))
            {
                int j = i-1, k = i+1;
                status = db->Put(QuasDB::WriteOptions(), text[k], text[j]);
            }
            i++;
        }
    }
}



int main()
{
    std::string str= "DELETE FROM \"cpu\" WHERE time < '2000-01-01T00:00:00Z'";
    //cout << str << endl;
    QuasDB::DB *db;
    QuasDB::Options options;
    options.create_if_missing = true;
    QuasDB::Status status = QuasDB::DB::Open(options, "/tmp/testdb", &db);
    parse(str,status,*db);
//    cout << "Hello world!" << endl;
    return 0;
}

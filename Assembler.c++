#include <iostream>
#include <fstream>
#include <map>
#include <vector>
#include <sstream>
#include <algorithm>
#include <cctype>

using namespace std;


string DecimalToBinary(int num)
{
    string str;
      while(num){
      if(num & 1) // 1
        str+='1';
      else // 0
        str+='0';
      num>>=1; // Right Shift by 1  
    }    

    int i = 0, j = str.size() - 1;
    while(i <= j)
    {
      swap(str[i], str[j]);
      i++;
      j--;
    }
      return str;
}


string calcImm(string imm) // note imm is hex value
{
    string binary = "";
    for (int i = 0; i < imm.size(); i++)
    {
        if (imm[i] == '0')
        {
            binary += "0000";
        }
        else if (imm[i] == '1')
        {
            binary += "0001";
        }
        else if (imm[i] == '2')
        {
            binary += "0010";
        }
        else if (imm[i] == '3')
        {
            binary += "0011";
        }
        else if (imm[i] == '4')
        {
            binary += "0100";
        }
        else if (imm[i] == '5')
        {
            binary += "0101";
        }
        else if (imm[i] == '6')
        {
            binary += "0110";
        }
        else if (imm[i] == '7')
        {
            binary += "0111";
        }
        else if (imm[i] == '8')
        {
            binary += "1000";
        }
        else if (imm[i] == '9')
        {
            binary += "1001";
        }
        else if (imm[i] == 'A' || imm[i] == 'a')
        {
            binary += "1010";
        }
        else if (imm[i] == 'B' || imm[i] == 'b')
        {
            binary += "1011";
        }
        else if (imm[i] == 'C' || imm[i] == 'c')
        {
            binary += "1100";
        }
        else if (imm[i] == 'D' || imm[i] == 'd')
        {
            binary += "1101";
        }
        else if (imm[i] == 'E' || imm[i] == 'e')
        {
            binary += "1110";
        }
        else if (imm[i] == 'F' || imm[i] == 'f')
        {
            binary += "1111";
        }
    }
    cout << "binary" << binary << endl;
    return binary;
}

const string R0 = "000";
const string R1 = "001";
const string R2 = "010";
const string R3 = "011";
const string R4 = "100";
const string R5 = "101";
const string R6 = "110";
const string R7 = "111";

int main()
{
    // distribution of opcode bits      immit    SCR2        SCR1      DST       Grp      cmd
    //                                    x      XXX         XXX      XXX       XXXX      XX        16 bits
    vector<string> outputOpCodes;
    multimap<string, string> instructionSet;
    string AdressOfInstruction ;
    {
        // opcode of command (Group ->4bits) (command ->2bits)

        // first group of commands

        instructionSet.insert(make_pair("NOP", "000000"));
        instructionSet.insert(make_pair("COMPARE", "000001"));

        // second group of commands
        instructionSet.insert(make_pair("NOT", "000100"));
        instructionSet.insert(make_pair("INC", "000101"));
        instructionSet.insert(make_pair("DEC", "000110"));
        instructionSet.insert(make_pair("ADD", "000111"));

        // third group of commands
        instructionSet.insert(make_pair("AND", "001000"));
        instructionSet.insert(make_pair("SUB", "001001"));
        instructionSet.insert(make_pair("OR", "001010"));
        instructionSet.insert(make_pair("XOR", "001011"));

        // fourth group of commands
        instructionSet.insert(make_pair("NEG", "001100"));
        instructionSet.insert(make_pair("SUBI", "001101"));
        instructionSet.insert(make_pair("ADDI", "001111"));

        // fifth group of commands
        instructionSet.insert(make_pair("IN", "010000"));
        instructionSet.insert(make_pair("OUT", "010001"));

        // sixth group of commands
        instructionSet.insert(make_pair("STD", "010111"));

        // seventh group of commands
        instructionSet.insert(make_pair("PUSH", "011000"));

        // eighth group of commands
        instructionSet.insert(make_pair("LDD", "011111"));

        // ninth group of commands
        instructionSet.insert(make_pair("LDM", "100000"));

        // tenth group of commands
        instructionSet.insert(make_pair("RET", "100100"));

        // eleventh group of commands
        instructionSet.insert(make_pair("SWAP", "101000"));
        instructionSet.insert(make_pair("MOV", "101001"));

        // twelveth group of commands
        instructionSet.insert(make_pair("PROTECT", "101110"));
        instructionSet.insert(make_pair("FREE", "101111"));

        // thirteenth group of commands
        instructionSet.insert(make_pair("JZ", "110000"));
        instructionSet.insert(make_pair("JMP", "110001"));

        // fourteenth group of commands
        instructionSet.insert(make_pair("CALL", "110100"));

        // fifteenth group of commands
        instructionSet.insert(make_pair("POP", "111000"));

        // sixteenth group of commands
        instructionSet.insert(make_pair("RTI", "111100"));
    }

    // string ss = "RtI";
    // for (char &c : ss)
    // {
    //     c = std::toupper(c);
    // }
    // cout << ss << endl;
    // cout << instructionSet.find(ss)->second << endl;

    // read text file
    ifstream file("test.txt");
    string line;
    vector<string> lines;
    while (getline(file, line))
    {
        //check if the line contain , then remove it
        line.erase(remove(line.begin(), line.end(), ','), line.end());
        lines.push_back(line);
    }
    file.close();

    ofstream output("output.mem");

    for (int i = 0; i < lines.size(); i++)
    {
        string oppCode = "";
        string bitImmidiate = "";
        string immVal = "";
        // take word by word ar radch line
        istringstream iss(lines[i]);
        string word;
        iss >> word;
        for (char &c : word)
        {
            c = std::toupper(c);
        }
        //check if the current instruction is .org [0-inifinty]
        if (word == ".ORG")
        {

            //then i need to get the address of the instruction
            
            iss >> AdressOfInstruction;
            cout<<"AdressOfInstruction: "<<AdressOfInstruction<<endl;
            istringstream dummy(lines[i+1]);

            dummy>>word;
            //check if word carries a string that is number then we need to push it to the output file
            if(word[0]>='0' && word[0]<='9')
            {
                string val=DecimalToBinary(stoi(word));

                while(val.size()<16)
                {
                    val="0"+val;
                }
                word=AdressOfInstruction +":  " + (val );
                outputOpCodes.push_back(word);
                //add plus one to the address
                AdressOfInstruction = to_string(stoi(AdressOfInstruction)+1);
                i++;
            }
            continue;

            
        }

        
        // check if word is in instruction set
        if (instructionSet.find(word) != instructionSet.end())
        {
            // cout<<word<<endl;
            // cout<<instructionSet.find(word)->second<<endl;
            oppCode += instructionSet.find(word)->second;
            cout << "got oppcode" << oppCode << endl;
        }
        // we need to check if the oppcode is immidate or not
        if (word == "ADDI" || word == "SUBI" || word == "LDM" || word == "LDD" || word == "STD")
        {
            // immidiate
            bitImmidiate = "1";
        }
        else
        {
            // not immidiate
            bitImmidiate = "0";
        }

        while (iss >> word)
        {
            cout<<"wordIntial: "<<word<<endl;
            if (word == "R0" || word == "r0")
            {
                cout << "entered R0" << endl;
                oppCode = R0 + oppCode;
                cout << "oppcode" << oppCode << endl;
            }
            else if (word == "R1" || word == "r1")
            {
                oppCode = R1 + oppCode;
            }
            else if (word == "R2" || word == "r2")
            {
                oppCode = R2 + oppCode;
            }
            else if (word == "R3" || word == "r3")
            {
                oppCode = R3 + oppCode;
            }
            else if (word == "R4" || word == "r4")
            {
                oppCode = R4 + oppCode;
            }
            else if (word == "R5" || word == "r5")
            {
                oppCode = R5 + oppCode;
            }
            else if (word == "R6" || word == "r6")
            {
                oppCode = R6 + oppCode;
            }
            else if (word == "R7" || word == "r7")
            {
                oppCode = R7 + oppCode;
            }

            else if (oppCode.substr(3, 9) == "100000")
            {
                cout<<"hello brozzz: "<<oppCode.size() <<endl;
                // then iam ldm i read opcode and dst now word has imm     [     www100000]  w 3 bits for rdst
                cout<<oppCode.substr(0,3)<<endl;
                if(oppCode.substr(0,3)=="000")
                {
                    cout<<"double sayoood"<<endl;
                    oppCode =R2 +R1 + oppCode;
                }
                else if(oppCode.substr(0,3)=="001")
                {
                    oppCode = R0 + R2 + oppCode;
                }
                else if(oppCode.substr(0,3)=="010")
                {
                    oppCode = R0 + R1 + oppCode;
                }
                // i need to covert imm which is now stored in word to bits
                cout << "oppCode final" << oppCode << endl;
                immVal = calcImm(word);
                cout << "mody" << immVal << endl;
            }
            else if (oppCode.substr(3, 9) == "011111")
            {
                // then iam ldd i read opcode and dst now word has eau(R[0-7])     [     www011111]  w are 3 bits for rdst
                // scr2 dont care
                // adding scr1
                cout<<"ldd"<<endl;

                if (word.substr(5, 6) == "R0)")
                {
                    oppCode = R0 + oppCode;
                }
                else if (word.substr(5, 6) == "R1)")
                {
                    cout << "ismail gone" << endl;

                    oppCode = R1 + oppCode;
                }
                else if (word.substr(5, 6) == "R2)")
                {
                    cout << "ismail gone" << endl;
                    oppCode = R2 + oppCode;
                }
                else if (word.substr(5, 6) == "R3)")
                {
                    oppCode = R3 + oppCode;
                }
                else if (word.substr(5, 6) == "R4)")
                {
                    oppCode = R4 + oppCode;
                }
                else if (word.substr(5, 6) == "R5)")
                {
                    oppCode = R5 + oppCode;
                }
                else if (word.substr(5, 6) == "R6)")
                {
                    oppCode = R6 + oppCode;
                }
                else if (word.substr(5, 6) == "R7)")
                {
                    oppCode = R7 + oppCode;
                }
                // adding scr2
                oppCode = "010" + oppCode; // note this is dont care for scr2
                immVal = calcImm(word.substr(0, 4));
            }
            else if (oppCode.substr(3, 9) == "010111")
            {
                // then i am store i read opcode and dst now word has eau(R[0-7])     [     www011111]  w are 3 bits for rdst
                //  scr1 dont care
                cout<<"std"<<endl;
                // adding scr1
                // note this is dont care for scr1
                int zero = 1;
                int one = 1;
                int two = 1;
                if(oppCode.substr(0,2)=="000" || word.substr(5, 6) == "R0)"||word.substr(5, 6) == "r0)" )
                {
                   zero=0;
                }
                else if (oppCode.substr(0,2)=="001" || word.substr(5, 6) == "R1)"||word.substr(5, 6) == "r1)")
                {
                   one = 0;
                }
                else if (oppCode.substr(0,2)=="010" || word.substr(5, 6) == "R2)"||word.substr(5, 6) == "r2)")
                {
                   two = 0;
                }
                if(zero==1)
                {
                    oppCode = R0 + oppCode;
                }
                else if(one==1)
                {
                    oppCode = R1 + oppCode;
                }
                else if(two==1)
                {
                    oppCode = R2 + oppCode;
                }

                // adding scr2
                if (word.substr(5, 6) == "R0)" || word.substr(5, 6) == "r0)")
                {
                    oppCode = R0 + oppCode;
                }
                else if (word.substr(5, 6) == "R1)" || word.substr(5, 6) == "r1)")
                {
                    cout << "ismail gone" << endl;

                    oppCode = R1 + oppCode;
                }
                else if (word.substr(5, 6) == "R2)" || word.substr(5, 6) == "r2)")
                {
                    cout << "ismail gone" << endl;
                    oppCode = R2 + oppCode;
                }
                else if (word.substr(5, 6) == "R3)" || word.substr(5, 6) == "r3)")
                {
                    oppCode = R3 + oppCode;
                }
                else if (word.substr(5, 6) == "R4)" || word.substr(5, 6) == "r4)")
                {
                    oppCode = R4 + oppCode;
                }
                else if (word.substr(5, 6) == "R5)" || word.substr(5, 6) == "r5)")
                {
                    oppCode = R5 + oppCode;
                }
                else if (word.substr(5, 6) == "R6)" || word.substr(5, 6) == "r6)")
                {
                    oppCode = R6 + oppCode;
                }
                else if (word.substr(5, 6) == "R7)" || word.substr(5, 6) == "r7)")
                {
                    oppCode = R7 + oppCode;
                }

                immVal = calcImm(word.substr(0, 4));
            }
            else if (oppCode.substr(6, 11) == "001101" || oppCode.substr(6, 11) == "001111")
            {
                // then i am subi or addi i read opcode and dst now word has imm     [     www011111]  w are 3 bits for rdst
                // scr2 dont care
                // adding scr1
                immVal = calcImm(word);
                 cout<<"word:"<<word<<endl;

                cout << "w4o4 5yna" << immVal<< endl;
            }
            word = "";
            cout<<"no oppCode"<<oppCode<<endl;
        }

        cout << lines[i] << endl;
        // we need to write the output to the file
        while (oppCode.size() < 15)
        { 
            // i need to fill the rest of bits with one r[0-7] that not used before
            cout<<"need to add some bits"<<endl;
            if(oppCode.size()==6 )
            {   
                //then no r like nop 
                cout<<"Fixing by method 1"<<endl;
                oppCode = R0 + oppCode;
                oppCode = R1 + oppCode;
                oppCode = R2 + oppCode;
            }
            else if(oppCode.size()==9)
            {
                //then we have one Reg in oppcode 
                int zero = 1;
                int one = 1;
                int two = 1;
                cout<<"Fixing by method 2"<<endl;
                if(oppCode.substr(0,2)=="000")
                {
                    zero=0;
                }
                else if(oppCode.substr(0,2)=="001")
                {
                    one=0;
                }
                else if(oppCode.substr(0,2)=="010")
                {
                    two=0;
                }
                if(zero==1)
                {
                    oppCode = R0 + oppCode;
                }
                 if(one==1)
                {
                    oppCode = R1 + oppCode;
                }
                 if(two==1 && (!one || !zero))
                {
                    oppCode = R2 + oppCode;
                }
            }
            else if(oppCode.size()==12)
            {
                
                //then we have two Reg in oppcode
                cout<<"Fixing by method 3"<<endl;
                int zero = 1;
                int one = 1;
                int two = 1;
                //then we have two Reg in oppcode 
                if(oppCode.substr(0,2)=="000" || oppCode.substr(3,5)=="000")
                {
                    zero=0;
                }
                else if(oppCode.substr(0,2)=="001" || oppCode.substr(3,5)=="001")
                {
                    one=0;
                }
                else if(oppCode.substr(0,2)=="010" || oppCode.substr(3,5)=="010")
                {
                    two=0;
                }
                if(zero==1)
                {
                    oppCode = R0 + oppCode;
                }
                else if(one==1)
                {
                    oppCode = R1 + oppCode;
                }
                else if(two==1)
                {
                    oppCode = R2 + oppCode;
                }
            }
        
        }
        oppCode = bitImmidiate + oppCode;
        oppCode=AdressOfInstruction +":  " + oppCode;
        AdressOfInstruction = to_string(stoi(AdressOfInstruction)+1);

        outputOpCodes.push_back(oppCode);
        // output << oppCode << endl;
        if (bitImmidiate == "1")
        {
            cout << "imaval" << immVal << endl;
            // write immVal to file output.txt
            // output << immVal << endl;
             outputOpCodes.push_back(immVal);
        }
    }
    cout<<"ellisa"<<endl;

    for (int i = 0; i < outputOpCodes.size(); i++)
    {
        for (int j = 0; j < outputOpCodes.size() - 1; j++)
        {
            if (stoi(outputOpCodes[j].substr(0, outputOpCodes[j].find(":"))) > stoi(outputOpCodes[j + 1].substr(0, outputOpCodes[j + 1].find(":"))))
            {
                string temp = outputOpCodes[j];
                outputOpCodes[j] = outputOpCodes[j + 1];
                outputOpCodes[j + 1] = temp;
            }
        }
    }



    for (int i = 0; i < outputOpCodes.size(); i++)
    {
        output << outputOpCodes[i] << endl;
    }
    output.close();

    return 0;
}

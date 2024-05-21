#include <iostream>
#include <fstream>
#include <map>
#include <vector>
#include <sstream>
#include <algorithm>
#include <cctype>
#include <bitset>
#include <regex>

using namespace std;

string getValueBetweenBrackets(const string &word)
{
    std::size_t first = word.find_first_of("(");
    std::size_t last = word.find_last_of(")");
    if (first == string::npos || last == string::npos || first >= last)
    {
        return "";
    }
    return word.substr(first + 1, last - first - 1);
}

int hexToDec(const std::string &hex)
{
    return stoi(hex, nullptr, 16);
}

string DecimalToBinary(int num)
{

    string str;
    while (num)
    {
        if (num & 1) // 1
            str += '1';
        else // 0
            str += '0';
        num >>= 1; // Right Shift by 1
    }

    int i = 0, j = str.size() - 1;
    while (i <= j)
    {
        swap(str[i], str[j]);
        i++;
        j--;
    }
    return str;
}

string decToHex(int dec)
{
    std::stringstream ss;
    ss << std::hex << dec;
    return ss.str();
}

string hexToBin(const string &hex)
{
    // i need to check here if the the passed value is a hexadecimal or not
    // if the value is a hexadecimal then i need to convert it to binary

    unsigned long dec = stoul(hex, nullptr, 16);
    std::bitset<16> bin(dec);

    return bin.to_string();
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
    bool check = true;
    vector<string> outputOpCodes;
    multimap<string, string> instructionSet;
    string AdressOfInstruction;
    {
        // opcode of command (Group ->4bits) (command ->2bits)

        // first group of commands

        instructionSet.insert(make_pair("NOP", "000000"));
        instructionSet.insert(make_pair("CMP", "000001"));

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

    // read text file
    ifstream file("test.txt");
    string line;
    vector<string> lines;
    while (getline(file, line))
    {
        // i need to remove the comments from the line comments can be in a separete line like this # comment or beside a line like this ADD R0 R1 # comment
        line = line.substr(0, line.find("#"));
        if (line.empty())
            continue;
        // check if the line contain , then remove it
        line.erase(remove(line.begin(), line.end(), ','), line.end());
        lines.push_back(line);
    }
    file.close();
    ofstream output("output.mem");
    string s = "// memory data file (do not edit the following line - required for mem load use)";
    output << s << endl;
    s = "// instance=/fetch_stage/instruction_cache/ram";
    output << s << endl;
    s = "// format=mti addressradix=d dataradix=s version=1.0 wordsperline=1";
    output << s << endl;

    for (int i = 0; i < lines.size(); i++)
    {
        string instruction = ""; // collect all bits here
        string oppCode = "";     // done
        string threeRegs = "";
        string bitImmidiate = ""; // done
        string immVal = "";

        // take word by word ar radch line
        istringstream iss(lines[i]);
        string word;
        iss >> word;
        for (char &c : word)
        {
            c = std::toupper(c);
        }
        // check if the current instruction is .org [0-inifinty]
        if (word == ".ORG")
        {

            // then i need to get the address of the instruction

            iss >> AdressOfInstruction;
            istringstream dummy(lines[i + 1]);

            dummy >> word;
            // check if word carries a string that is number then we need to push it to the output file
            if (word[0] >= '0' && word[0] <= '9')
            {
                string val ="00000000000000000000000000000000";

                 val = DecimalToBinary(stoi(word));

                while (val.size() < 32)
                {
                    val = "0" + val;
                }
                // i need to push split the string to two parts each one is 16 bits and push it to the output file

                //
                word = AdressOfInstruction + ":  " + (val.substr(16, 32));

                outputOpCodes.push_back(word);
                // add plus one to the address
                AdressOfInstruction = to_string(stoi(AdressOfInstruction) + 1);
                word = AdressOfInstruction + ":  " + (val.substr(0, 16));

                outputOpCodes.push_back(word);
                AdressOfInstruction = to_string(stoi(AdressOfInstruction) + 1);
                i++;
            }
            else if(check)
            {
                string val ="00000000000000000000000000000010";

                word = AdressOfInstruction + ":  " + (val.substr(16, 32));

                outputOpCodes.push_back(word);
                // add plus one to the address
                AdressOfInstruction = to_string(stoi(AdressOfInstruction) + 1);
                word = AdressOfInstruction + ":  " + (val.substr(0, 16));

                outputOpCodes.push_back(word);
                AdressOfInstruction = to_string(stoi(AdressOfInstruction) + 1);
                i++;
            }
            check = false;

            continue;

        }

        // check if word is in instruction set
        if (instructionSet.find(word) != instructionSet.end())
        {
            oppCode += instructionSet.find(word)->second;
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

        // zero operand
        if (oppCode == "100100" || oppCode == "111100" || oppCode == "000000")
        {
            // then i have no registers
            threeRegs = "010001000";
        }
        // we go the oppcode now we need to get the registers
        while (iss >> word)
        {

            // check if the word is a register always first read will be reg and will be the destination
            if (word == "R0" || word == "r0")
            {
                threeRegs = R0 + threeRegs;
            }
            else if (word == "R1" || word == "r1")
            {
                threeRegs = R1 + threeRegs;
            }
            else if (word == "R2" || word == "r2")
            {
                threeRegs = R2 + threeRegs;
            }
            else if (word == "R3" || word == "r3")
            {
                threeRegs = R3 + threeRegs;
            }
            else if (word == "R4" || word == "r4")
            {
                threeRegs = R4 + threeRegs;
            }
            else if (word == "R5" || word == "r5")
            {
                threeRegs = R5 + threeRegs;
            }
            else if (word == "R6" || word == "r6")
            {
                threeRegs = R6 + threeRegs;
            }
            else if (word == "R7" || word == "r7")
            {
                threeRegs = R7 + threeRegs;
            }
            // check on the uninary operand
            if (oppCode == "000100" || oppCode == "000101" || oppCode == "000110" || oppCode == "001100" || oppCode == "010000" || oppCode == "010001" || oppCode == "011000" || oppCode == "111000" || oppCode == "110000" || oppCode == "110001" || oppCode == "110100" || oppCode == "101110" || oppCode == "101111")
            {
                // then  i have only one register which is the destination and same as src1 and src2 is dummy value
                if (threeRegs.size() < 4)
                {
                    threeRegs += threeRegs;
                    if (threeRegs.substr(0, 3) != R0)
                    {
                        threeRegs = R0 + threeRegs;
                    }
                    else if (threeRegs.substr(0, 3) != R1)
                    {
                        threeRegs = R1 + threeRegs;
                    }
                }
            }
            // two operands
            else if ((oppCode == "101000" || oppCode == "101001" || oppCode == "000001") && threeRegs.size() > 0)
            {

                // then i have two registers first one is the destination and its the same as scr1  and the second is the scr2
                if (threeRegs.size() < 4)
                {
                    threeRegs += threeRegs;
                }
            }

            else if (oppCode == "010111" && threeRegs.size() > 0)
            {
                // then i am store i read opcode and dst
                // scr1 same as destination

                // now word has ea(R[0-7])
                //  i need to get from word the value between the brackets note maybe in form AAAA(R0) or 1(R0) ...etc
                //  i need to get the value between the brackets

                string reg = getValueBetweenBrackets(word); // the shape must be AAAA(R7)
                if (threeRegs.size() < 4)
                {
                    threeRegs += threeRegs;
                }

                reg[0] = toupper(reg[0]);
                // adding scr2
                if (reg == "R0")
                {
                    threeRegs = R0 + threeRegs;
                }
                else if (reg == "R1")
                {

                    threeRegs = R1 + threeRegs;
                }
                else if (reg == "R2")
                {
                    threeRegs = R2 + threeRegs;
                }
                else if (reg == "R3")
                {
                    threeRegs = R3 + threeRegs;
                }
                else if (reg == "R4")
                {
                    threeRegs = R4 + threeRegs;
                }
                else if (reg == "R5")
                {
                    threeRegs = R5 + threeRegs;
                }
                else if (reg == "R6")
                {
                    threeRegs = R6 + threeRegs;
                }
                else if (reg == "R7")
                {
                    threeRegs = R7 + threeRegs;
                }

                // i need to check before that if the value is a hexadecimal or not the shape of the passed value is AAAA or 1 or 0000 or 0002 or 2
                // if the value is a hexadecimal then i need to convert it to binary

                string imm = word.substr(0, word.find("("));

                if (regex_match(imm, regex("[0-9a-fA-F]+")))
                {

                    immVal = hexToBin(imm); // on 16 bit
                }
            }

            else if ((oppCode == "001101" || oppCode == "001111") && threeRegs.size() == 6)
            {
                // then i am subi or addi i read opcode and dst now word has imm
                // scr2 dont care
                //  scr1 is added  now  and i should handle the imm value
                // we need to add scr2
                if (threeRegs.substr(0, 3) != R0 && threeRegs.substr(3, 6) != R0)
                {
                    threeRegs = R0 + threeRegs;
                }
                else if (threeRegs.substr(0, 3) != R1 && threeRegs.substr(3, 6) != R1)
                {
                    threeRegs = R1 + threeRegs;
                }
                else if (threeRegs.substr(0, 3) != R2 && threeRegs.substr(3, 6) != R2)
                {
                    threeRegs = R2 + threeRegs;
                }
                iss >> word;
                immVal = hexToBin(word);
            }

            else if (oppCode == "100000" && threeRegs.size() > 0)
            {
                // then i am ldm i read opcode and dst now word has imm
                threeRegs = threeRegs + threeRegs;
                if (threeRegs.substr(0, 3) != "000")
                {
                    threeRegs = R0 + threeRegs;
                }
                else if (threeRegs.substr(0, 3) != "001")
                {
                    threeRegs = R1 + threeRegs;
                }
                iss >> word; // now word has imm
                // i need to covert imm which is now stored in word to bits
                immVal = hexToBin(word);
            }
            else if (oppCode == "011111" && threeRegs.size() > 0)
            {
                // then iam ldd i read opcode and dst now word has eau(R[0-7])     [     www011111]  w are 3 bits for rdst
                // scr2 dont care
                // adding scr1
                iss >> word;
                string reg = getValueBetweenBrackets(word); // the shape must be AAAA(R7)

                reg[0] = toupper(reg[0]);
                // adding scr2
                if (reg == "R0")
                {
                    threeRegs = R0 + threeRegs;
                }
                else if (reg == "R1")
                {

                    threeRegs = R1 + threeRegs;
                }
                else if (reg == "R2")
                {
                    threeRegs = R2 + threeRegs;
                }
                else if (reg == "R3")
                {
                    threeRegs = R3 + threeRegs;
                }
                else if (reg == "R4")
                {
                    threeRegs = R4 + threeRegs;
                }
                else if (reg == "R5")
                {
                    threeRegs = R5 + threeRegs;
                }
                else if (reg == "R6")
                {
                    threeRegs = R6 + threeRegs;
                }
                else if (reg == "R7")
                {
                    threeRegs = R7 + threeRegs;
                }

                // i need to check before that if the value is a hexadecimal or not the shape of the passed value is AAAA or 1 or 0000 or 0002 or 2
                // if the value is a hexadecimal then i need to convert it to binary

                string imm = word.substr(0, word.find("("));

                if (regex_match(imm, regex("[0-9a-fA-F]+")))
                {

                    immVal = hexToBin(imm); // on 16 bit
                }
                if (threeRegs.substr(0, 3) != R0 && threeRegs.substr(3, 6) != R0)
                {
                    threeRegs = R0 + threeRegs;
                }
                else if (threeRegs.substr(0, 3) != R1 && threeRegs.substr(3, 6) != R1)
                {
                    threeRegs = R1 + threeRegs;
                }
                else if (threeRegs.substr(0, 3) != R2 && threeRegs.substr(3, 6) != R2)
                {
                    threeRegs = R2 + threeRegs;
                }
            }
        }

        // now we have the oppcode and the registers
        // we need to add the immidiate bit
        instruction += oppCode;
        instruction = threeRegs + instruction;
        instruction = bitImmidiate + instruction;
        // we need to push the instruction the  outputOpCodes vector
        if(instruction.size() < 14)
        {
            continue;
        }
        instruction = AdressOfInstruction + ":  " + instruction;
        AdressOfInstruction = to_string(stoi(AdressOfInstruction) + 1);
        outputOpCodes.push_back(instruction);
        if (bitImmidiate == "1")
        {
            immVal = AdressOfInstruction + ":  " + immVal;
            AdressOfInstruction = to_string(stoi(AdressOfInstruction) + 1);
            outputOpCodes.push_back(immVal);
        }
    }

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

    // Add padding to the output
    int max_length = 0;
    for (const auto &line : outputOpCodes)
    {
        size_t pos = line.find(":");
        if (pos != std::string::npos && pos - 1 > max_length)
        {
            max_length = pos - 1;
        }
    }

    for (auto &line : outputOpCodes)
    {
        size_t pos = line.find(":");
        if (pos != std::string::npos && pos != 0)
        {
            line.insert(pos - 1, max_length - (pos - 1), ' ');
        }
    }
    // removing all space empty before :
    for (auto &line : outputOpCodes)
    {
        size_t pos = line.find(":");
        if (pos != std::string::npos && pos != 0)
        {
            for (int i = 0; i < pos; i++)
            {
                if (line[i] == ' ')
                {
                    line.erase(i, 1);
                }
            }
        }
    }

        // Write to the file
        for (const auto &line : outputOpCodes)
        {
            if(line.size() > 0)
            output << line << endl;
        }
        output.close();

        return 0;
    }
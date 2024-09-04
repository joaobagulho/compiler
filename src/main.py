#!/usr/bin/env python3
import sys, os, getopt
from antlr4 import *
from antlr4.tree.Tree import TerminalNodeImpl
from antlr4.tree.Trees import Trees
from antlr.simpleLexer import simpleLexer as Lexer
from antlr.simpleParser import simpleParser as Parser
from antlr.simpleListener import simpleListener as Listener

expath = os.path.abspath(os.path.dirname(sys.argv[0]))
options = {
    "verbose": False,
    "output": None
}

def main(argv=[]):
    try:
        opts, args = getopt.getopt(argv, "ho:v", ["help", "output=", "verbose"])
    except getopt.GetoptError as err:
        print(f"ERROR: {err}!")
        usage()
        sys.exit(2)

    for opt, arg in opts:
        if(opt in ("-v", "--verbose")):
            options["verbose"] = True
        elif(opt in ("-h", "--help")):
            usage()
            sys.exit()
        elif(opt in ("-o", "--output")):
            options["output"] = arg
        else:
            assert False, "unhandled option"
    
    if(options["output"] == None):
        print("WARN: output file was not provided! printing!")

    for arg in args:
        if(not (os.path.exists(arg) and os.path.isfile(arg))):
            print(f"ERROR: file \"{arg}\" does not exist!")
            sys.exit(-1)
        
        analize(arg)

def analize(path):
    ifile = open(path, "r")
    lexer = Lexer(InputStream(ifile.read()))
    ifile.close()
    stream = CommonTokenStream(lexer)
    parser = Parser(stream)

    tree = parser.root()

    #print(tree.toStringTree(recog=parser))
    
    if(options["output"] == None):
        print(dump(tree, ruleNames=parser.ruleNames))
    else:
        ofile = open(options["output"], "w")
        if(ofile.writable()):
            ofile.write(dump(tree, ruleNames=parser.ruleNames))
        else:
            print(f"ERROR: failed to open file \"{options['output']}\" for writing!")

    return None


def dump(node, depth=0, ruleNames=None):
    out = ""
    depthStr = '  ' * depth
    if(isinstance(node, TerminalNodeImpl)):
        symb = node.getText()
        if(options["verbose"] == True):
            symb = node.symbol
        return (f'{depthStr}{depth} \"{symb}\"\n')
    else:
        out += (f'{depthStr}{depth} {Trees.getNodeText(node, ruleNames)}:\n')
        if(node.children == None):
            return ""
        for child in node.children:
            out += dump(child, depth + 1, ruleNames)
        return out


def usage():
    pass

if(__name__ == "__main__"):
    main(sys.argv[1:])

#214 finished
#HS finished
#CET6 finished
#green finished
#red finished
#CET4 finished
import sys  
import xlrd
data = xlrd.open_workbook("SAT.xlsx")
#table = data.sheets()[0]
#nrows = table.nrows
#rowValues = table.row_values(i)
#rowValues[0]
listNumber = 0
for j in range (1):
    table = data.sheets()[j]
    nrows = table.nrows
    for i in range(nrows):
        rowValues = table.row_values(i)
        if rowValues[1].strip()=="" and rowValues[0].strip()!="" and rowValues[2]=="":
            listNumber = listNumber+1
        elif rowValues[1].strip()=="" and rowValues[0].strip()=="":
            continue
        else:
            word = rowValues[0].strip().replace(" ","_")+"\t"+rowValues[2].replace(" ","").replace("\n","")+"\t"+str(listNumber)
            print(word)
                

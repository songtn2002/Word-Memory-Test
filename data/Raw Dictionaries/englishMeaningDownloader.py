import xlrd
import xlwt

dataIn = xlrd.open_workbook("SAT.xlsx")
tableIn = data.sheets()[0]
rowNumIn = table.nrows

for i in range (rowNumIn):
    rowValues = table.row_values(i)
    if not rowValues[0].contains("List"):

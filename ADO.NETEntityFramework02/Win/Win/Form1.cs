using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Win
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            FileInfo newFile = new FileInfo("Data.xlsx");
            using (ExcelPackage pck = new ExcelPackage(newFile))
            {
                ExcelWorksheet ws = pck.Workbook.Worksheets.Add("bb");

                ws.Cells[1, 1].Value = "Company name";
                ws.Cells[1, 2].Value = "Address";
                ws.Cells[1, 3].Value = "Status (unstyled)";

                // Add the second row of header data
                ws.Cells[2, 1].Value = "Vehicle registration plate";
                ws.Cells[2, 2].Value = "Vehicle brand";
                pck.Save();
            }
        }
    }
   
}

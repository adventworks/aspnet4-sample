using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace EmbedVideoWinForm
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        List<string> list1 = new List<string> { "1", "2", "3" };
        List<string> list2 = new List<string> { "4", "5", "6" };
        ListBox lbx = new ListBox();
       
        private void btnLoad_Click(object sender, EventArgs e)
        {

            List<string> list = new List<string> { "aaa", "bbb", "ccc" };
            LoadDatasource(listBox1,list,"Button Loading",1);
        }
        
        public void LoadDatasource(ListBox lbx,Object dSource, string display,int idx)
        {
            if (lbx.DataSource != null)
            {
                lbx.DataSource = null;
            }
            lbx.DisplayMember = display;
            lbx.DataSource = dSource;
            lbx.SelectedIndex =idx;

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            List<string> list = new List<string> { "123", "465", "798" };
            LoadDatasource(listBox1, list, "Form Loading", 0);
        }
    }
}

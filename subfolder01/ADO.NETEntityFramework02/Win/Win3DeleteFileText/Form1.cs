using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Win3DeleteFileText
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            StreamWriter location = new StreamWriter(@"C:\Users\v-jianpw\Desktop\Mb.txt", true);
            location.WriteLine(textBox1.Text);
            location.Close();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (comboBox1.SelectedIndex >= 0)
            {
                string filename = @"C:\Users\v-jianpw\Desktop\Mb.txt";
                string[] lines = File.ReadAllLines(filename);
                textBox2.Text = (lines[comboBox1.SelectedIndex]);
            }

        }
    }
    }


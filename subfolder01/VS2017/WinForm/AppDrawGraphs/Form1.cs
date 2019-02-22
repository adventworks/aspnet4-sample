using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace AppDrawGraphs
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            Graphs g;
            //Here im giving reference to picturebox that i created in designer
            Thread t = new Thread(() => g = new Graphs(PictureBox1));
            t.IsBackground = true;
            t.Start();
        }
        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }
    class Graphs
    {
        int X = 0, Y = 0;
        PictureBox box1;
        List<Point> PointsList = new List<Point>();

        public Graphs(PictureBox pb1)
        {
            box1 = pb1;
            box1.Paint += new PaintEventHandler(Graph1Redraw);
            TimeCounter();
        }
        private System.Windows.Forms.Timer Timer1;
        private void TimeCounter()
        {
            Timer1 = new System.Windows.Forms.Timer();
            Timer1.Tick += new EventHandler(Graph1);
            Timer1.Interval = 1000;
            Timer1.Start();
        }

        private void Graph1(object sender, EventArgs e)
        {
            //Counting x and y here and adding it to pointslist
            PointsList.Add(new Point(X, Y));
            //Activating trigger
            box1.Invalidate();
        }
        private void Graph1Redraw(object sender, PaintEventArgs e)
        {
            Graphics g = e.Graphics;
            // Doing some drawing on box1 with g.FillRectangle()
            // Drawing some lines on box1 with g.DrawLines()
        }
    }
}

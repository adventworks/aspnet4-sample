using AForge.Video.FFMPEG;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace WindowsFormsApp2
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string basePaths = @"C:\Users\v-jianpw\Desktop\CSharp";

            string[] paths = Directory.GetFiles(basePaths);
            int imagesCount = paths.Length;
            using (var vFWriter = new VideoFileWriter())
            {
                vFWriter.Open(@"D:\videos.avi", 1600, 900, 1, VideoCodec.MPEG4, 1000000);//setting the width and the heigh of video are the same as your pictures(the width and heigh of all pictures are the same.) 
                for (int i = 1; i < imagesCount; i++)
                {
                    var imagePath = string.Format(paths[i]);
                    using (Bitmap image = Bitmap.FromFile(imagePath) as Bitmap)
                    {
                        vFWriter.WriteVideoFrame(image);
                    }
                }

            }
        }
    }
}

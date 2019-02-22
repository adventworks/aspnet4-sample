using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
//using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using AForge.Video.FFMPEG;
using System.IO;

namespace App2ImagesToVideo
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            string basePaths = @"C:\Users\v-jianpw\Desktop\New folder";
            
            string[] paths=Directory.GetFiles(basePaths);
            int imagesCount = paths.Length;
            using (var vFWriter = new VideoFileWriter())
            {
                vFWriter.Open(@"D:\videos.avi",3956,2176,15,VideoCodec.MPEG4,1000000);
                for(int i=1;i< imagesCount; i++)
                {
                    var imagePath = string.Format(paths[i]);
                    //using (Bitmap image=Bitmap.FromFile(imagePath) as Bitmap)
                    //{
                    //    vFWriter.WriteVideoFrame(image);
                    //}
                }

            }
        }
       
    }
}

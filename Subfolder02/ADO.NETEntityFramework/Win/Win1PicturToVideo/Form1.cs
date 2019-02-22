using SharpAvi;
using SharpAvi.Output;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Win1PicturToVideo
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            
            InitializeComponent();
        }

        public int PictureNumber = 0;
        public int CaptureInterval = 100;
        private void button1_Click(object sender, EventArgs e)
        {
            timer1.Start();
            button2.Enabled = true;
            button1.Enabled = false;
        }
        private void button2_Click(object sender, EventArgs e)
        {
            PictureNumber = 0;
            timer1.Stop();
            timer2.Stop();
            button1.Enabled = true;
            button2.Enabled = false;
        }
        private void button3_Click(object sender, EventArgs e)
        {
            CaptureInterval += 100;
            label2.Text = CaptureInterval.ToString();
            timer1.Interval = CaptureInterval;
        }
        private void button4_Click(object sender, EventArgs e)
        {
            if (CaptureInterval > 100)
            {
                CaptureInterval -= 100;
                label2.Text = CaptureInterval.ToString();
                timer1.Interval = CaptureInterval;
            }
        }
        private void timer1_Tick(object sender, EventArgs e)
        {

            PictureNumber += 1;
            SendKeys.Send("{PRTSC}");
            //pictureBox1.Image = null;
            Image img = Clipboard.GetImage();
            img.Save("D:\\Pictures\\image" + PictureNumber + ".jpg");
            pictureBox1.Image = img;
        }
        private void Play()
        {
            string[] allFile = Directory.GetFiles("D:\\Pictures");
            foreach (var item in allFile)
            {
                //File file = new FileInfo();
                Image image = Image.FromFile(item);
                pictureBox1.Image = image;
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            string[] files = Directory.GetFiles(@"C:\Users\v-jianpw\Desktop\New folder");
            //AviWriter aviWrite = new AviWriter(files[0]);
            GenerateSingleImageVideo(files[4]);
            
        }

        private void GenerateSingleImageVideo(string filePath)
        {
            string imagePath = filePath;
            Bitmap thisBitmap;

            //generate bitmap from image file
            using (Stream BitmapStream = System.IO.File.Open(imagePath, FileMode.Open))
            {
                Image img = Image.FromStream(BitmapStream);
                thisBitmap = new Bitmap(img);
            }

            //convert the bitmap to a byte array
            byte[] byteArray = BitmapToByteArray(thisBitmap);

            //creates the writer of the file (to save the video)
            var writer = new AviWriter(@"C:\Users\v-jianpw\Desktop\New folder\11.avi");
            //writer.FramesPerSecond = byteArray.Length;
            var stream = writer.AddVideoStream();
            stream.Width = thisBitmap.Width;
            stream.Height = thisBitmap.Height;
            stream.Codec = KnownFourCCs.Codecs.Uncompressed;
            stream.BitsPerPixel = BitsPerPixel.Bpp32;

            int numberOfFrames = 1 * 100;// ((int.Parse("1.0")) * (int.Parse("100.0")));
            int count = 0;

            while (count <= 10)
            {
                stream.WriteFrame(true, byteArray, 0, byteArray.Length);
                count++;
            }
           
            writer.Close();
            MessageBox.Show("Done");


        }

        private byte[] BitmapToByteArray(Bitmap img)
        {
            ImageConverter converter = new ImageConverter();
            return (byte[])converter.ConvertTo(img, typeof(byte[]));
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button6_Click(object sender, EventArgs e)
        {
            string str = "St1TUzIxAAADnpwECAUHCc7QAAAbn2kBAAAAg0MdYp45APgPmgCHAAmR";
            byte[] bytes = Encoding.Unicode.GetBytes(str);
            
            int columns =20;
            int rows = 5;
            int stride = columns;
            byte[] newbytes = PadLines(bytes, rows, columns);

            Bitmap im = new Bitmap(columns, rows, stride,
                     PixelFormat.Format8bppIndexed,
                     Marshal.UnsafeAddrOfPinnedArrayElement(newbytes, 0));

            im.Save(@"C:\Users\v-jianpw\Desktop\New folder\image21.jpg");
        }
        static byte[] PadLines(byte[] bytes, int rows, int columns)
        {
            int currentStride = columns; // 3
            int newStride = columns;  // 4
            byte[] newBytes = new byte[newStride * rows];
            for (int i = 0; i < rows; i++)
                Buffer.BlockCopy(bytes, currentStride * i, newBytes, newStride * i, currentStride);
            return newBytes;
        }
    }
}

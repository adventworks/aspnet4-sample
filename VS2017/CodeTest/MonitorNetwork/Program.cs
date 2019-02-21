using SharpPcap;
using PacketDotNet;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Net;
using System.Diagnostics;
using System.Threading;
namespace ConsoleApplication1
{
    //记录特定进程性能信息的类
    public class ProcessPerformanceInfo : IDisposable
    {
        public int ProcessID { get; set; }//进程ID
        public string ProcessName { get; set; }//进程名
        public float PrivateWorkingSet { get; set; }//私有工作集(KB)
        public float WorkingSet { get; set; }//工作集(KB)
        public float CpuTime { get; set; }//CPU占用率(%)
        public float IOOtherBytes { get; set; }//每秒IO操作（不包含控制操作）读写数据的字节数(KB)
        public int IOOtherOperations { get; set; }//每秒IO操作数（不包括读写）(个数)
        public long NetSendBytes { get; set; }//网络发送数据字节数
        public long NetRecvBytes { get; set; }//网络接收数据字节数
        public long NetTotalBytes { get; set; }//网络数据总字节数
        public List<ICaptureDevice> dev = new List<ICaptureDevice>();

        /// <summary>
        /// 实现IDisposable的方法
        /// </summary>
        public void Dispose()
        {
            foreach (ICaptureDevice d in dev)
            {
                d.StopCapture();
                d.Close();
            }
        }
    }
    class Program
    {
        public static ProcessPerformanceInfo ProcInfo { get; set; }
        static void Main(string[] args)
        {
            ProcInfo = new ProcessPerformanceInfo()
            {
                ProcessID = 12104
            };

            //进程id
            int pid = ProcInfo.ProcessID;
            //存放进程使用的端口号链表
            List<int> ports = new List<int>();
            #region 获取指定进程对应端口号
            Process pro = new Process();
            pro.StartInfo.FileName = "cmd.exe";
            pro.StartInfo.UseShellExecute = false;
            pro.StartInfo.RedirectStandardInput = true;
            pro.StartInfo.RedirectStandardOutput = true;
            pro.StartInfo.RedirectStandardError = true;
            pro.StartInfo.CreateNoWindow = true;
            pro.Start();
            pro.StandardInput.WriteLine("netstat -ano");
            pro.StandardInput.WriteLine("exit");
            Regex reg = new Regex("\\s+", RegexOptions.Compiled);
            string line = null;
            ports.Clear();
            while ((line = pro.StandardOutput.ReadLine()) != null)
            {
                line = line.Trim();
                if (line.StartsWith("TCP", StringComparison.OrdinalIgnoreCase))
                {
                    line = reg.Replace(line, ",");
                    string[] arr = line.Split(',');
                    if (arr[4] == pid.ToString())
                    {
                        string soc = arr[1];
                        int pos = soc.LastIndexOf(':');
                        int pot = int.Parse(soc.Substring(pos + 1));
                        ports.Add(pot);
                    }
                }
                else if (line.StartsWith("UDP", StringComparison.OrdinalIgnoreCase))
                {
                    line = reg.Replace(line, ",");
                    string[] arr = line.Split(',');
                    if (arr[3] == pid.ToString())
                    {
                        string soc = arr[1];
                        int pos = soc.LastIndexOf(':');
                        int pot = int.Parse(soc.Substring(pos + 1));
                        ports.Add(pot);
                    }
                }
            }
            pro.Close();
            #endregion

            //获取本机IP地址


            //IPAddress[] addrList = Dns.GetHostByName(Dns.GetHostName()).AddressList;
            IPAddress[] allIP = Dns.GetHostEntry(Dns.GetHostName()).AddressList;
            string IP = allIP[3].ToString();
            //获取本机网络设备
            ///var devices = SharpPcap.WinPcap.WinPcapDeviceList.Instance;
            var devices = CaptureDeviceList.Instance;
            int count = devices.Count;
            if (count < 1)
            {
                Console.WriteLine("No device found on this machine");
                return;
            }


            //开始抓包
            for (int i = 0; i < count; ++i)
            {
                for (int j = 0; j < ports.Count; ++j)
                {
                    CaptureFlowRecv(IP, ports[j], i);
                    CaptureFlowSend(IP, ports[j], i);
                }
            }
            while (true)
            {
                Console.WriteLine("proc NetTotalBytes : " + ProcInfo.NetTotalBytes);
                Console.WriteLine("proc NetSendBytes : " + ProcInfo.NetSendBytes);
                Console.WriteLine("proc NetRecvBytes : " + ProcInfo.NetRecvBytes);

                //每隔1s调用刷新函数对性能参数进行刷新
                RefershInfo();
            }
            //最后要记得调用Dispose方法停止抓包并关闭设备
            //Proc.Dispose();
        }
        public static void CaptureFlowSend(string IP, int portID, int deviceID)
        {
            ICaptureDevice device = (ICaptureDevice)CaptureDeviceList.New()[deviceID];

            device.OnPacketArrival += new PacketArrivalEventHandler(device_OnPacketArrivalSend);

            int readTimeoutMilliseconds = 1000;
            device.Open(DeviceMode.Promiscuous, readTimeoutMilliseconds);

            string filter = "src host " + IP + " and src port " + portID;
            device.Filter = filter;
            device.StartCapture();
            ProcInfo.dev.Add(device);
        }

        public static void CaptureFlowRecv(string IP, int portID, int deviceID)
        {
            ICaptureDevice device = CaptureDeviceList.New()[deviceID];
            device.OnPacketArrival += new PacketArrivalEventHandler(device_OnPacketArrivalRecv);

            int readTimeoutMilliseconds = 1000;
            device.Open(DeviceMode.Promiscuous, readTimeoutMilliseconds);

            string filter = "dst host " + IP + " and dst port " + portID;
            device.Filter = filter;
            device.StartCapture();
            ProcInfo.dev.Add(device);
        }
        private static void device_OnPacketArrivalSend(object sender, CaptureEventArgs e)
        {
            var len = e.Packet.Data.Length;
            ProcInfo.NetSendBytes += len;
        }

        private static void device_OnPacketArrivalRecv(object sender, CaptureEventArgs e)
        {
            var len = e.Packet.Data.Length;
            ProcInfo.NetRecvBytes += len;
        }
        /// <summary>
        /// 实时刷新性能参数
        /// </summary>
        public static void RefershInfo()
        {
            ProcInfo.NetRecvBytes = 0;
            ProcInfo.NetSendBytes = 0;
            ProcInfo.NetTotalBytes = 0;
            Thread.Sleep(1000);
            ProcInfo.NetTotalBytes = ProcInfo.NetRecvBytes + ProcInfo.NetSendBytes;
        }
    }
}

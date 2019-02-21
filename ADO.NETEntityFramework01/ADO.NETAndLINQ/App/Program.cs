using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace App
{
    class Program
    {
        static void Main(string[] args)
        {
            //DateTime fromDate = new DateTime(1990, 1, 1);
            //DateTime toDate = new DateTime(2000, 1, 1);
            //List<int> SalesRepIds = new List<int> { 1, 2, 3, 4, 5, 6 };
            //string ServiceType = "Residential";
            //MyDbContext dataContext = new MyDbContext();

            List<string> delList = new List<string>();
            delList.Add("197.168.0.11");
            delList.Add("197.168.0.12");
            delList.Add("197.168.0.13");
            string ips = string.Join(", ", delList.Select(ip => $"'{ip}'"));

            //var result = from c in dataContext.CustomerDbEntities
            //             join m in dataContext.MessageDbEntities on c.CustomerId equals m.CustomerId
            //             join cc in dataContext.CustomerContractDbEntities on c.CustomerId equals cc.CustomerId
            //             join t in dataContext.TransactionTypeDbEntities on m.TransactionTypeId equals t.TranactionTypeId
            //             where t.Code == "TOFF" && m.CreatedOn >= fromDate && m.CreatedOn <= toDate && c.ServiceTypeId == (ServiceType == "Residential" ? 0 : 1)
            //             orderby m.CreatedOn descending //You could sort your data according to your requirement
            //             ///select m;
            //             group m by t.Code into groups // You could group your data according to your requiement
            //             select groups.FirstOrDefault();
            Console.ReadKey();
        }

    }








    public class CustomerDbEntity
    {
        public int CustomerId { set; get; }
        public int SalesmenId { set; get; }
        public int ServiceTypeId { set; get; }

        public string InvoiceBillingName { set; get; }
    }

    public class MessageDbEntity
    {
        public int MessageDbEntityID { set; get; }
        public int CustomerId { set; get; }
        public int TransactionTypeId { set; get; }
        public DateTime CreatedOn { set; get; }
    }
    public class TransactionTypeDbEntity
    {
        public int TranactionTypeId { set; get; }
        public string Code { set; get; }
    }
    public class SalesmenDbEntity
    {
        public int SalesmenId { set; get; }

        public string FullName { set; get; }
    }
    public class CustomerContractDbEntity
    {
        public int ContractRateTypeId { set; get; }
        public int CustomerId { get; set; }
    }
    public class ContractRateTypeDbEntity
    {
        public int ContractRateTypeId { set; get; }
        public string Description { set; get; }
    }
    public class MyDbContext
    {
        public List<CustomerDbEntity> CustomerDbEntities { set; get; }
        public List<MessageDbEntity> MessageDbEntities { set; get; }
        public List<TransactionTypeDbEntity> TransactionTypeDbEntities { set; get; }
        public List<SalesmenDbEntity> SalesmenDbEntities { set; get; }
        public List<CustomerContractDbEntity> CustomerContractDbEntities { set; get; }
        public List<ContractRateTypeDbEntity> ContractRateTypeDbEntities { set; get; }
        public MyDbContext()
        {
            CustomerDbEntities = new List<CustomerDbEntity> {
                new CustomerDbEntity {CustomerId=1,SalesmenId=1,ServiceTypeId=1,InvoiceBillingName="a"},
                new CustomerDbEntity {CustomerId=2,SalesmenId=2,ServiceTypeId=0,InvoiceBillingName="b"},
                new CustomerDbEntity {CustomerId=3,SalesmenId=3,ServiceTypeId=1,InvoiceBillingName="c"},
                new CustomerDbEntity {CustomerId=4,SalesmenId=4,ServiceTypeId=0,InvoiceBillingName="d"},
                new CustomerDbEntity {CustomerId=5,SalesmenId=5,ServiceTypeId=1,InvoiceBillingName="f"},
            };
            MessageDbEntities = new List<MessageDbEntity> {
                new MessageDbEntity { MessageDbEntityID=1,CustomerId=1,TransactionTypeId=1,CreatedOn=DateTime.Now},
                new MessageDbEntity { MessageDbEntityID=2,CustomerId=2,TransactionTypeId=2,CreatedOn=new DateTime(1997,11,12) },
                new MessageDbEntity { MessageDbEntityID=3,CustomerId=3,TransactionTypeId=3,CreatedOn=new DateTime(1998,11,12)},
                new MessageDbEntity { MessageDbEntityID=4,CustomerId=4,TransactionTypeId=4,CreatedOn=new DateTime(1999,11,12)},
                new MessageDbEntity { MessageDbEntityID=5,CustomerId=5,TransactionTypeId=5,CreatedOn=new DateTime(1996,11,12)},
            };
            TransactionTypeDbEntities = new List<TransactionTypeDbEntity> {
                new TransactionTypeDbEntity { TranactionTypeId=1,Code="3333"},
                new TransactionTypeDbEntity { TranactionTypeId=2,Code="TOFF"},
                new TransactionTypeDbEntity { TranactionTypeId=3,Code="2222"},
                new TransactionTypeDbEntity { TranactionTypeId=4,Code="TOFF"},
                new TransactionTypeDbEntity { TranactionTypeId=5,Code="1111"},
            };
            SalesmenDbEntities = new List<SalesmenDbEntity> {
                new SalesmenDbEntity { SalesmenId =1,FullName="aa"},
                new SalesmenDbEntity { SalesmenId =2,FullName="bb"},
                new SalesmenDbEntity { SalesmenId =3,FullName="cc"},
                new SalesmenDbEntity { SalesmenId =4,FullName="dd"},
                new SalesmenDbEntity { SalesmenId =5,FullName="ff"},
            };
            CustomerContractDbEntities = new List<CustomerContractDbEntity> {
                new CustomerContractDbEntity { ContractRateTypeId=1,CustomerId=1 },
                new CustomerContractDbEntity { ContractRateTypeId=2,CustomerId=2 },
                new CustomerContractDbEntity { ContractRateTypeId=3,CustomerId=3 },
                new CustomerContractDbEntity { ContractRateTypeId=4,CustomerId=4 },
                new CustomerContractDbEntity { ContractRateTypeId=5,CustomerId=5 },
            };
            ContractRateTypeDbEntities = new List<ContractRateTypeDbEntity> {
                new ContractRateTypeDbEntity { ContractRateTypeId=1,Description="bbbb"},
                new ContractRateTypeDbEntity { ContractRateTypeId=2,Description="aaaa"},
                new ContractRateTypeDbEntity { ContractRateTypeId=3,Description="cccc"},
                new ContractRateTypeDbEntity { ContractRateTypeId=4,Description="dddd"},
                new ContractRateTypeDbEntity { ContractRateTypeId=5,Description="ffff"},
            };
        }
    }
    #region
    //public class MyDbContext : DbContext
    //{
    //    public DbSet<CustomerDbEntity> CustomerDbEntities { set; get; }

    //    public DbSet<MessageDbEntity> MessageDbEntities { set; get; }

    //    public DbSet<TransactionTypeDbEntity> TransactionTypeDbEntities { set; get; }

    //    public DbSet<SalesmenDbEntity> SalesmenDbEntities { set; get; }

    //    public DbSet<CustomerContractDbEntity> CustomerContractDbEntities { set; get; }

    //    public DbSet<ContractRateTypeDbEntity> ContractRateTypeDbEntities { set; get; }

    //}
    #endregion
}

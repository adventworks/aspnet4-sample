using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity;
namespace EFBulkInsertORM
{
    class Program
    {
        static void Main(string[] args)
        {
            using (AppDbContext dbContext = new AppDbContext())
            {
                //dbContext.Invoices.AddRange(new List<Invoice> {
                //    new Invoice {InvoiceNumber = "001", InvoiceDate = DateTime.Now,InvoiceItems=new List<Invoci> },
                //    new Invoice {InvoiceNumber = "002", InvoiceDate = DateTime.Now },
                //    new Invoice {InvoiceNumber = "003", InvoiceDate = DateTime.Now }
                //});
                dbContext.InvoiceItems.AddRange(new List<InvoiceItem> { new InvoiceItem { } });
               // dbContext.BulkInsert(new List<Invoice> { new Invoice { } });
            }
        }
    }
    public class Invoice
    {
        [Key]
        public int InvoiceId { get; set; }
        public string InvoiceNumber { get; set; }
        public DateTime InvoiceDate { get; set; }

        public ICollection<InvoiceItem> InvoiceItems { get; set; }
    }

    public class InvoiceItem
    {
        [Key]
        public int InvoiceItemId { get; set; }
        public string ItemNumber { get; set; }
        public string PartDescription { get; set; }
        public int PartQuantity { get; set; }
        public double PartPrice { get; set; }

        public int InvoiceId { get; set; }
        public virtual Invoice Invoice { get; set; }
    }
    public class AppDbContext : DbContext
    {
        public AppDbContext() : base("DefaultConnection") { }
        public DbSet<Invoice> Invoices { get; set; }
        public DbSet<InvoiceItem> InvoiceItems { get; set; }
    }
}

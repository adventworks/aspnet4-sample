using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace IncludeTwoCollections.Models
{
    public class ShopCategory
    {
        public int Id { set; get; }

        public virtual List<ProductInfo> InfoItems { set; get; }
        public virtual List<Product> Products { set; get; }

    }
    public class Product
    {
        public int ProductID { set; get; }

        public int ShopCategoryID { set; get; }
        public ShopCategory ShopCategory { set; get; }

        public virtual List<ProductInfo> InfoItems { get; set; } = new List<ProductInfo>();
        public virtual List<ProductGraphic> GraphicItems { get; set; } = new List<ProductGraphic>();
    }
    public class ProductInfo
    {
        [Key]
        public int ProductInforId { set; get; }

        public int ProductID { set; get; }
        public virtual Product Product { set; get; }

        public int ShopCategoryID { set; get; }
        public virtual ShopCategory ShopCategory { set; get; }
    }
    public class ProductGraphic
    {
        public int ProductGraphicID { set; get; }

        public int ProductID { set; get; }
        public virtual Product Product { set; get; }

        public int GraphicID { set; get; }
        public virtual Graphic Graphic { set; get; }

    }
    public class Graphic
    {
        public int GraphicID { set; get; }

        public List<Item> Items { set; get; }
    }
    public class Item
    {
        public int ItemID { set; get; }
        public int GraphicID { set; get; }
        public virtual Graphic Graphic { set; get; }

    }
    public class IncludeTwoCollectionDbContext : DbContext
    {
        public DbSet<ShopCategory> ShopCategorys { set; get; }
        public DbSet<Product> Products { set; get; }
        public DbSet<ProductInfo> ProductInfos { set; get; }
        public DbSet<ProductGraphic> GraphicItems { set; get; }
    }
}
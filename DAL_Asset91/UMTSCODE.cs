//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DAL
{
    using System;
    using System.Collections.Generic;
    
    public partial class UMTSCODE
    {
        public decimal KEY { get; set; }
        public decimal PROJECTNO { get; set; }
        public decimal SCHEMAKEY { get; set; }
        public string SCHEMANAME { get; set; }
        public decimal CODEGROUP { get; set; }
        public decimal CODE { get; set; }
        public decimal NETWORKTYPE { get; set; }
        public Nullable<decimal> CREATEUSER { get; set; }
        public Nullable<decimal> USERGROUP { get; set; }
        public Nullable<System.DateTime> CREATEDATE { get; set; }
        public Nullable<System.DateTime> MODIFYDATE { get; set; }
        public decimal MODIFYUSER { get; set; }
        public Nullable<decimal> PERMISSION { get; set; }
    
        public virtual UMTSCODESCHEMA UMTSCODESCHEMA { get; set; }
    }
}
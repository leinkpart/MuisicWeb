//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MusicWeb.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Lyric
    {
        public int LyricID { get; set; }
        public Nullable<int> SongID { get; set; }
        public string LyricText { get; set; }
    
        public virtual Song Song { get; set; }
    }
}

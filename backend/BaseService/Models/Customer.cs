using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DBase.Models
{
    public class Customer
    {
        [Key]
        public Guid ID_Customer { get; set; } = Guid.NewGuid();
        [Required]
        [MaxLength(100)] 
        public string? CustomerName { get; set; }
        [Required]
        [MaxLength(50)] 
        public string? Phone { get; set; }
        [Required]
        [MaxLength(50)] 
        public string? Email { get; set; }
        [Required]
        [MaxLength(200)] 
        public string? Address { get; set; }
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Auto { get; set; }

        // public virtual ICollection<Order>? Orders { get; set; } // Navigation property
    }
}


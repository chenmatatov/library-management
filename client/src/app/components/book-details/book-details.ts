import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router, ActivatedRoute } from '@angular/router';
import { Book } from '../../models/model';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-book-details',
  imports: [CommonModule],
  templateUrl: './book-details.html',
  styleUrl: './book-details.css',
})
export class BookDetailsComponent implements OnInit {
  book: Book | null = null;
  loading = true;
  bookId?: number;
  statuses: any[] = [];
  locations: any[] = [];

  constructor(
    private apiService: ApiService,
    private router: Router,
    private route: ActivatedRoute,
    private cdr: ChangeDetectorRef
  ) {}

  ngOnInit(): void {
    this.bookId = Number(this.route.snapshot.paramMap.get('id'));
    if (this.bookId) {
      this.loadData();
    }
  }

  loadData(): void {
    this.loading = true;
    
    // קודם טוען את הספר, אחר כך סטטוסים ומיקומים
    this.loadBook();
    
    // טוען סטטוסים ומיקומים ברקע
    this.apiService.getStatuses().subscribe({
      next: (statuses) => {
        this.statuses = statuses || [];
        this.cdr.detectChanges();
      },
      error: (error) => {
        console.error('Error loading statuses:', error);
        this.statuses = [];
        this.cdr.detectChanges();
      }
    });
    
    this.apiService.getLocations().subscribe({
      next: (locations) => {
        this.locations = locations || [];
        this.cdr.detectChanges();
      },
      error: (error) => {
        console.error('Error loading locations:', error);
        this.locations = [];
        this.cdr.detectChanges();
      }
    });
  }

  loadBook(): void {
    this.loading = true;
    this.apiService.getBookById(this.bookId!).subscribe({
      next: (data) => {
        if (data && data.length > 0) {
          this.book = data[0];
        }
        this.loading = false;
        this.cdr.detectChanges();
      },
      error: (error) => {
        console.error('Error loading book:', error);
        this.loading = false;
        this.cdr.detectChanges();
      }
    });
  }

  onEdit(): void {
    this.router.navigate(['/book-form', this.bookId]);
  }

  onBack(): void {
    this.router.navigate(['/books']);
  }

  getStatusName(statusId: number): string {
    const status = this.statuses.find(s => s.ID == statusId);
    return status ? status.Name : 'לא ידוע';
  }

  getLocationName(locationId: number): string {
    const location = this.locations.find(l => l.ID == locationId);
    return location ? location.LocationName : 'לא ידוע';
  }
}

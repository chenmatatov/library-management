import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { ReactiveFormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { ApiService } from '../../services/api.service';
import { Book, Status, Location } from '../../models/model';

@Component({
  selector: 'app-book-form',
  imports: [ReactiveFormsModule, CommonModule],
  templateUrl: './book-form.html',
  styleUrl: './book-form.css',
})
export class BookFormComponent implements OnInit {
  bookForm: FormGroup;
  isEdit = false;
  bookId?: number;
  loading = false;
  statuses: any[] = [];
  locations: any[] = [];
  
  // הודעות
  showNotification = false;
  notificationMessage = '';
  notificationType: 'success' | 'error' | 'info' = 'success';

  constructor(
    private fb: FormBuilder,
    private apiService: ApiService,
    private router: Router,
    private route: ActivatedRoute,
    private cdr: ChangeDetectorRef
  ) {
    this.bookForm = this.fb.group({
      Title: ['', Validators.required],
      Author: ['', Validators.required],
      Category: ['', Validators.required],
      Description: [''],
      PublishYear: ['', [Validators.required, Validators.min(1000)]],
      AvailableCopies: ['', [Validators.required, Validators.min(0)]],
      StatusId: ['', Validators.required],
      LocationId: ['', Validators.required]
    });
  }

  ngOnInit() {
    this.bookId = Number(this.route.snapshot.paramMap.get('id'));
    if (this.bookId) {
      this.isEdit = true;
    }
    this.loadData();
  }

  loadData() {
    this.loading = true;
    
    // טוען סטטוסים ומיקומים
    this.apiService.getStatuses().subscribe({
      next: (statuses) => {
        this.statuses = statuses || [];
        
        this.apiService.getLocations().subscribe({
          next: (locations) => {
            this.locations = locations || [];
            
            if (this.isEdit) {
              this.loadBook();
            } else {
              this.loading = false;
            }
          },
          error: (error) => {
            console.error('Error loading locations:', error);
            this.locations = [];
            if (this.isEdit) {
              this.loadBook();
            } else {
              this.loading = false;
            }
          }
        });
      },
      error: (error) => {
        console.error('Error loading statuses:', error);
        this.statuses = [];
        this.locations = [];
        if (this.isEdit) {
          this.loadBook();
        } else {
          this.loading = false;
        }
      }
    });
  }

  loadBook() {
    this.apiService.getBookById(this.bookId!).subscribe({
      next: (data) => {
        if (data && data.length > 0) {
          const book = data[0];
          this.bookForm.patchValue(book);
        }
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading book:', error);
        this.loading = false;
      }
    });
  }

  showMessage(message: string, type: 'success' | 'error' | 'info' = 'success'): void {
    console.log('Showing message:', message, type);
    console.log('showNotification before:', this.showNotification);
    this.notificationMessage = message;
    this.notificationType = type;
    this.showNotification = true;
    this.cdr.detectChanges(); // כפיית עדכון
    console.log('showNotification after:', this.showNotification);
    console.log('notificationMessage:', this.notificationMessage);
    console.log('notificationType:', this.notificationType);
  }

  onNotificationClose(): void {
    this.showNotification = false;
  }

  goToBooksList(): void {
    this.router.navigate(['/books']);
  }

  onSubmit() {
    console.log('onSubmit called');
    console.log('Form valid:', this.bookForm.valid);
    
    if (this.bookForm.valid) {
      this.loading = true;
      const bookData = { ...this.bookForm.value };
      console.log('Book data:', bookData);
      
      if (this.isEdit && this.bookId) {
        bookData.BookId = this.bookId;
        console.log('Updating book with ID:', this.bookId);
        this.apiService.updateBook(bookData).subscribe({
          next: () => {
            console.log('Book updated successfully');
            this.loading = false;
            this.showMessage('הספר עודכן בהצלחה! 🎉', 'success');
          },
          error: (error) => {
            console.error('Error updating book:', error);
            this.showMessage('שגיאה בעדכון הספר ❌', 'error');
            this.loading = false;
          }
        });
      } else {
        console.log('Creating new book');
        this.apiService.createBook(bookData).subscribe({
          next: () => {
            console.log('Book created successfully');
            this.loading = false;
            this.showMessage('הספר נוסף בהצלחה! 🎉', 'success');
          },
          error: (error) => {
            console.error('Error creating book:', error);
            this.showMessage('שגיאה בהוספת הספר ❌', 'error');
            this.loading = false;
          }
        });
      }
    } else {
      console.log('Form is invalid');
      this.showMessage('אנא מלא את כל השדות החובה ⚠️', 'error');
    }
  }

  cancel() {
    this.router.navigate(['/books']);
  }
}
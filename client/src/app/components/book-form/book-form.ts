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
        this.loading = false;
      }
    });
  }

  showMessage(message: string, type: 'success' | 'error' | 'info' = 'success'): void {
    this.notificationMessage = message;
    this.notificationType = type;
    this.showNotification = true;
    this.cdr.detectChanges();
  }

  onNotificationClose(): void {
    this.showNotification = false;
  }

  goToBooksList(): void {
    this.router.navigate(['/books']);
  }

  onSubmit() {
    if (!this.bookForm.valid) {
      this.showMessage('אנא מלא את כל השדות החובה ⚠️', 'error');
      return;
    }

    this.loading = true;
    const bookData = { ...this.bookForm.value };

    if (this.isEdit && this.bookId) {
      bookData.BookId = this.bookId;

      this.apiService.updateBook(bookData).subscribe({
        next: () => {
          this.loading = false;
          this.showMessage('הספר עודכן בהצלחה! 🎉', 'success');
        },
        error: () => {
          this.showMessage('שגיאה בעדכון הספר ❌', 'error');
          this.loading = false;
        }
      });
    } else {
      this.apiService.createBook(bookData).subscribe({
        next: () => {
          this.loading = false;
          this.showMessage('הספר נוסף בהצלחה! 🎉', 'success');
        },
        error: () => {
          this.showMessage('שגיאה בהוספת הספר ❌', 'error');
          this.loading = false;
        }
      });
    }
  }

  cancel() {
    this.router.navigate(['/books']);
  }
}

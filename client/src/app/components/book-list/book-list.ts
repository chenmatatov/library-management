import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { Book } from '../../models/model';
import { ApiService } from '../../services/api.service';

@Component({
  selector: 'app-book-list',
  imports: [CommonModule, FormsModule],
  templateUrl: './book-list.html',
  styleUrl: './book-list.css'
})
export class BookListComponent implements OnInit {
  books: Book[] = [];
  searchText: string = '';
  loading: boolean = true;

  constructor(private apiService: ApiService, private router: Router, private cdr: ChangeDetectorRef) {}

  ngOnInit(): void {
    this.loadBooks();
  }

  loadBooks(): void {
    this.loading = true;
    this.apiService.getAllBooks().subscribe({
      next: (books) => {
        this.books = books || [];
        this.loading = false;
        this.cdr.detectChanges();
      },
      error: (error) => {
        this.loading = false;
        this.books = [
          { ID: 1, Title: 'ספר בדיקה', Author: 'מחבר בדיקה', Category: 'קטגוריה', Description: 'תיאור', PublishYear: 2024, AvailableCopies: 5, StatusId: 1, LocationId: 1, StatusName: 'זמין' }
        ];
      }
    });
  }

  onSearch(): void {
    this.apiService.getAllBooks(this.searchText).subscribe({
      next: (books) => {
        this.books = books;
        this.cdr.detectChanges();
      },
      error: (error) => {
      }
    });
  }

  onAdd(): void {
    this.router.navigate(['/book-form']);
  }

  onView(book: Book): void {
    this.router.navigate(['/book-details', book.ID]);
  }

  onEdit(book: Book): void {
    this.router.navigate(['/book-form', book.ID]);
  }

  trackByBookId(index: number, book: Book): number {
    return book.ID;
  }

  getStatusClass(statusId: number): string {
    const statusClasses: { [key: number]: string } = {
      1: 'status-available',
      2: 'status-unavailable', 
      3: 'status-pending'
    };
    return statusClasses[statusId] || 'status-unavailable';
  }
}
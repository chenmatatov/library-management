import { Routes } from '@angular/router';
import { BookListComponent } from './components/book-list/book-list';
import { BookFormComponent } from './components/book-form/book-form';
import { BookDetailsComponent } from './components/book-details/book-details';

export const routes: Routes = [
  { path: '', redirectTo: '/books', pathMatch: 'full' },
  { path: 'books', component: BookListComponent },
  { path: 'book-form', component: BookFormComponent },
  { path: 'book-form/:id', component: BookFormComponent },
  { path: 'book-details/:id', component: BookDetailsComponent }
];

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = 'https://localhost:7141/api/execute';

  constructor(private http: HttpClient) { }

  execute(procedureName: string, parameters: any = {}): Observable<any> {
    return this.http.post(this.apiUrl, {
      procedureName,
      parameters
    });
  }

  getAllBooks(searchText?: string): Observable<any> {
    return this.execute('Books_GetAll', { SearchText: searchText });
  }

  getBookById(id: number): Observable<any> {
    return this.execute('Books_GetById', { Id: id });
  }

  createBook(book: any): Observable<any> {
    return this.execute('Books_Create', book);
  }

  updateBook(book: any): Observable<any> {
    return this.execute('UpdateBook', book);
  }

  getStatuses(): Observable<any> {
    return this.execute('Statuses_GetAll');
  }

  getLocations(): Observable<any> {
    return this.execute('Locations_GetAll');
  }
   ChangeStatus(bookid: number,statusid: number): Observable<any> {
    return this.execute('ChangeStatus', {BookID: bookid,NewStatusID: statusid});
  }
}
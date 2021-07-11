import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { User } from 'src/app/models/user.model';

const ip = '127.0.0.1';

@Injectable({
  providedIn: 'root'
})
export class AuthentificationService {

  constructor(
    private http: HttpClient,
  ) {

  }

  sendLogin(data: User): Observable<User | Observable<never>> {
    return this.http.post<User>(
      `${ip}/users/signin/`,
      data
    ).pipe(
      catchError(error => of(throwError(error)))
    );
  }

  sendRegister(data: User): Observable<User | Observable<never>> {
    return this.http.post<User>(
      `${ip}/users/signup/`,
      data
    ).pipe(
      catchError(error => of(throwError(error)))
    );
  }

}

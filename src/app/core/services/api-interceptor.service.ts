import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpHandler, HttpEvent, HttpRequest } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, tap } from 'rxjs/operators';
import { ApiErrorHandlerService } from './api-error-handler.service';
import { ErrorHandlerDataDTO } from '../models/dto';

@Injectable({
	providedIn: 'root'
})
export class ApiInterceptorService implements HttpInterceptor {

	constructor(
		private apiErrorHandler: ApiErrorHandlerService
	) { }

	intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
		const requestHandler$ = (req): Observable<any> => {
			return next.handle(req).pipe(
				tap(response => {
					// Check whether translation was loaded.
					//console.log(response);
				}),
				catchError((response: any) => {
					this.apiErrorHandler.handleError(response, {
						params: {},
						message: null
					} as ErrorHandlerDataDTO);

					return throwError(response);
				})
			);
		};

		return requestHandler$(request);
	}
}

import { Injectable } from '@angular/core';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { from } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ModalDialogService {

	constructor(
		private modalService: NgbModal
	) { }

	runDialog = function(content) {
		const modalRef = this.modalService.open(content, { centered: true });

		return from(modalRef.result);
	};
}

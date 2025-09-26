import { Injectable } from '@angular/core';


@Injectable({
  providedIn: 'root'
})
export class UtilService {
    constructor() {}

    getFileNameFromUrl(url: string) {
        return url.split('/').pop();
    }
    addDays(date, days) {
      var result = new Date(date);
      result.setDate(result.getDate() + days);
      return result;
    }
}

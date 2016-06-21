import { Injectable } from '@angular/core';
import { Counter } from './counter';

let COUNTERS = [
  new Counter('hostname1', 10, 30),
  new Counter('hostname2', 10, 30),
  new Counter('hostname3', 10, 30)
];

let countersPromise = Promise.resolve(COUNTERS);

@Injectable()
export class CounterService {
  getCounters() { return countersPromise; }

  getCounter(hostname: string) {
    return countersPromise
      .then(counters => counters.filter(c => c.hostname === hostname)[0]);
  }
}
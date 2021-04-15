class StorageManager {
  private storage: Storage;

  constructor(storage: Storage) {
    this.storage = storage;
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  public get(key: string): any {
    const value = this.storage.getItem(key);
    if (!value) return null;
    try {
      return JSON.parse(value);
    } catch(e) {
      return value;
    }
  }

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  public set(key: string, value: any) {
    if (typeof value === 'string') {
      this.storage.setItem(key, value);
    } else {
      this.storage.setItem(key, JSON.stringify(value));
    }
  }

  public remove(key: string) {
    this.storage.removeItem(key);
  }
}

const localStorageManager = new StorageManager(localStorage);
const sessionStorageManager = new StorageManager(sessionStorage);

export {
  localStorageManager,
  sessionStorageManager,
};

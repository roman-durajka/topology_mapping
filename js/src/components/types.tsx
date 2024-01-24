export type CustomFunction = {
  name: string;
  fun: () => void;
};

export type PathTableItem = {
  pathId: number;
  name: string;
  assetValue: number;
  color: string;
  fun: () => void;
};

export type FormItem = {
  label: string;
  propertyName: string;
  selectOptions?: string[];
};

export type ColumnItem = {
  title: string;
  dataIndex: string;
  width: string;
  editable: boolean;
};

export type SubColumnItem = {
  title: string;
  dataIndex: string;
};

export type SubColumnGroup = {
  title: string;
  children: SubColumnItem[];
};

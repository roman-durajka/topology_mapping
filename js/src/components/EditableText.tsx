import React, { useEffect, useRef, useState } from "react";
import { Typography } from "antd";

const { Paragraph } = Typography;

interface InterfaceEditableText {
  text: string;
  onChange: (newText: string, ...args: any) => void;
}

const EditableText: React.FC<InterfaceEditableText> = ({ text, onChange }) => {
  const [editableStr, setEditableStr] = useState(text);
  const initialText = useRef(true);

  useEffect(() => {
    if (initialText.current == true) {
      initialText.current = false;
    } else {
      onChange(editableStr);
    }
  }, [editableStr]);

  return (
    <>
      <Paragraph editable={{ onChange: setEditableStr }}>
        {editableStr}
      </Paragraph>
    </>
  );
};

export default EditableText;

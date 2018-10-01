// @flow

import React, { type Node } from 'react';
import styled from 'styled-components';

const Flex = styled.div`
  font-family: Arial, Helvetica, sans-serif;
  height: 100vh;
  display: flex;
  align-content: center;
  justify-content: center;
`;

const FlexItem = styled.div`
  height: auto;
  width: auto;
  margin: auto;
`;

type PropsType = {
  children: Node,
}

const Showcase = ({ children }: PropsType) => (
  <Flex>
    <FlexItem>
      {children}
    </FlexItem>
  </Flex>
)

export default Showcase;

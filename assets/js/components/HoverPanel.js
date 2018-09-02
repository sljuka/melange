import React from 'react';
import { Motion, spring } from 'react-motion';
import styled from 'styled-components';
import { connect } from 'react-redux';
import RPT from 'prop-types';
import { withState, compose, withHandlers } from 'recompose';

const springConf = { stiffness: 200, damping: 15 };

const Container = styled.div`
  border: 1px solid black;
  position: relative;
  font-family: "Helvetica", "Arial", sans-serif;
`;

const FloatingPanel = styled.div.attrs({
  style: ({ left }) => ({ left: `${left}%` }),
})`
  border: 1px solid black;
  position: absolute;
  top: 10px;
  background-color: #f1f1f1;
  width: 50%;
  height: 440px;
  font-size: 1em;
`;

const FlexContainer = styled.div`
  position: relative;
  display: flex;
  flex-wrap: nowrap;
  justify-content: space-around;
  text-align: start;
  border: 1px solid;
`;

const FlexPanel = styled.div`
  background-color: white;
  width: 400px;
  height: 400px;
  text-align: center;
  font-size: 1em;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: start;
`;

const FloatContainer = styled.div`
  padding: 70px 70px;
`;

type PropsType = {
  FirstPanel: React.Element<*>,
  SecondPanel: React.Element<*>,
  FirstHoverPanel: React.Element<*>,
  SecondHoverPanel: React.Element<*>,
  firstPanelSelected: Boolean,
  selectFirstPanel: () => void,
  selectSecondPanel: () => void,
}

type StateType = {
  firstPanelSelected: Boolean,
}

const HoverPanel = ({
  FirstPanel,
  SecondPanel,
  FirstHoverPanel,
  SecondHoverPanel,
  firstPanelSelected,
  selectFirstPanel,
  selectSecondPanel,
}: PropsType) => {
  const movePercentage = firstPanelSelected ? 5 : 45;
  const springInterpolation = spring(movePercentage, springConf);

  return (
    <FlexContainer>
      <FlexPanel>
        <FirstPanel selectPanel={selectFirstPanel} />
      </FlexPanel>
      <FlexPanel>
        <SecondPanel selectPanel={selectSecondPanel} />
      </FlexPanel>
      <Motion style={{ left: springInterpolation }}>
        {({ left }) => (
          <FloatingPanel left={left}>
            <FloatContainer>
              {firstPanelSelected && <FirstHoverPanel />}
              {!firstPanelSelected && <SecondHoverPanel />}
            </FloatContainer>
          </FloatingPanel>
        )}
      </Motion>
    </FlexContainer>
  );
}

export default compose(
  withState('firstPanelSelected', 'setFirstPanelSelected', true),
  withHandlers({
    selectFirstPanel: ({ setFirstPanelSelected }) => () => setFirstPanelSelected(true),
    selectSecondPanel: ({ setFirstPanelSelected }) => () => setFirstPanelSelected(false),
  })
)(HoverPanel)

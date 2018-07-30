import React from 'react';
import { Motion, spring } from 'react-motion';
import styled from 'styled-components';
import { connect } from 'react-redux';
import RPT from 'prop-types';

const springConf = { stiffness: 200, damping: 15 };

const Container = styled.div`
  border: 1px solid black;
  position: relative;
  max-width: 960px;
  margin: auto;
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
  display: flex;
  flex-wrap: nowrap;
  justify-content: space-around;
  text-align: start;
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
  LeftPanel: React.Element<*>,
  RightPanel: React.Element<*>,
  LeftHoverPanel: React.Element<*>,
  RightHoverPanel: React.Element<*>,
}

type StateType = {
  firstPanelSelected: Boolean,
}

export default class HoverPanel extends React.Component<StateType, PropsType> {
  constructor(props) {
    super(props);
    this.state = {
      firstPanelSelected: true,
    };
  }

  render() {
    const { firstPanelSelected } = this.state;
    const {
      LeftPanel,
      RightPanel,
      LeftHoverPanel,
      RightHoverPanel,
    } = this.props;
    const movePercentage = firstPanelSelected ? 5 : 45;
    const springInterpolation = spring(movePercentage, springConf);

    return (
      <Container>
        <FlexContainer>
          <FlexPanel>
            <LeftPanel selectPanel={() => this.setState({ firstPanelSelected: true })} />
          </FlexPanel>
          <FlexPanel>
            <RightPanel selectPanel={() => this.setState({ firstPanelSelected: false })} />
          </FlexPanel>
          <Motion style={{ left: springInterpolation }}>
            {({ left }) => (
              <FloatingPanel left={left}>
                <FloatContainer>
                  {firstPanelSelected && <LeftHoverPanel />}
                  {!firstPanelSelected && <RightHoverPanel />}
                </FloatContainer>
              </FloatingPanel>
            )}
          </Motion>
        </FlexContainer>
      </Container>
    );
  }
}

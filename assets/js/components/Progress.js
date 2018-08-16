import React from 'react';
import { Motion, spring } from 'react-motion';
import styled from 'styled-components';
import { connect } from 'react-redux';
import RPT from 'prop-types';

const springConf = { stiffness: 100, damping: 99 };

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

export default class Progress extends React.Component<StateType, PropsType> {
  constructor(props) {
    super(props);
    this.state = {
      tasks: [false, false, false],
    };
  }

  componentDidMount() {
    setTimeout(() => this.setState({ tasks: [false, true, false] }), 1000)
    setTimeout(() => this.setState({ tasks: [true, true, false] }), 2000)
    setTimeout(() => this.setState({ tasks: [true, true, true] }), 4000)
  }

  render() {
    const percentage = Math.ceil(this.state.tasks.filter(task => task).length * 33.3)
    console.log('PERC', percentage)
    const springInterpolation = spring(percentage, springConf);

    return (
      <Container>
        <Motion style={{ pct: springInterpolation }}>
          {({ pct }) => (
            <progress value={pct} max="100"></progress>
          )}
        </Motion>
      </Container>
    );
  }
}

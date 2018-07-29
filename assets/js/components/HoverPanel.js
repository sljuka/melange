import React from 'react';
import { Motion, spring } from 'react-motion';
import styled from 'styled-components';
import { connect } from 'react-redux';
import RPT from 'prop-types';
import { logIn } from '../actions/authentication';
import LoginPanel from '../components/LogInPanel';
import SignUpPanel from '../components/SignUpPanel';
import LoginForm from '../containers/LoginForm';

const springConf = { stiffness: 200, damping: 15 };

const Container = styled.div`
  position: relative;
  max-width: 960px;
  margin: auto;
`;

const FloatingPanel = styled.div.attrs({
  style: ({ left }) => ({ left: `${left}%` }),
})`
  position: absolute;
  top: -20px;
  background-color: #f1f1f1;
  width: 50%;
  height: 440px;
  font-size: 1em;
`;

const FlexContainer = styled.div`
  margin-top: 100px;
  display: flex;
  flex-wrap: nowrap;
  background-color: #9c9e9e;
  justify-content: space-around;
  text-align: start;
`;

const FlexPanel = styled.div`
  background-color: #9c9e9e;
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

export default class HoverPanel extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      firstPanelSelected: true,
    };
  }

  render() {
    const { firstPanelSelected } = this.state;
    const { onClick } = this.props;
    const leftPercentage = firstPanelSelected ? 5 : 45;
    const springAnimation = spring(leftPercentage, springConf);

    return (
      <Container>
        <FlexContainer>
          <FlexPanel>
            <LoginPanel onClick={() => this.setState({ firstPanelSelected: true })} />
          </FlexPanel>
          <FlexPanel>
            <SignUpPanel onClick={() => this.setState({ firstPanelSelected: false })} />
          </FlexPanel>
          <Motion style={{ left: springAnimation }}>
            {({ left }) => (
              <FloatingPanel left={left}>
                <FloatContainer>
                  {firstPanelSelected && <LoginForm handleSubmit={this.props.onClick} />}
                  {!firstPanelSelected && <span>TEST 2</span>}
                </FloatContainer>
              </FloatingPanel>
            )}
          </Motion>
        </FlexContainer>
      </Container>
    );
  }
}

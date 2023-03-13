interface AuroraProps {
    size: { width: string; height: string };
    pos: { top: string; left: string };
}

export const Aurora: React.FC<AuroraProps> = ({ pos, size }) => {
    return(
        <div
        style={{
          pointerEvents: "none",
          width: size.width,
          height: size.height,
          position: "absolute",
          top: pos.top,
          left: pos.left,
          transform: "translate(-50%, -50%)",
          zIndex: -1,
        }}
      ></div>
    );
};